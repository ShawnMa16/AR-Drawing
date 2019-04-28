//
//  ARSceneViewController + Extensions.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/28/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import SnapKit
import ARVideoKit

extension ARSceneViewController {
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if screenDown {
            addSphere()
        }
    }
}
//MARK:- Points and node positions(SCNVector3)
extension ARSceneViewController {
    
    // Push points into array for testing or classification
    private func addPoint(pointPos: (x: Float, y: Float)) {
        let point = Point(x: pointPos.x, y: pointPos.y, strokeID: self.strokeIDCount)
        guard !point.x.isNaN, !point.y.isNaN else {return}
        
        if !self.testingMode {
            if self.templatePoints[self.templatePoints.count - 1].isEmpty {
                self.templatePoints[self.templatePoints.count - 1].append(point)
                addInterestNode(id: self.strokeIDCount)
            } else {
                let lastPoint = self.templatePoints[self.templatePoints.count - 1].last
                let distance = Point.distanceBetween(pointA: point, pointB: lastPoint!)
                
                if distance > self.pointsThreshold {
                    self.templatePoints[self.templatePoints.count - 1].append(point)
                    addInterestNode(id: self.strokeIDCount)
                }
            }
        } else {
            if self.testingPoints.isEmpty {
                self.testingPoints.append(point)
                addInterestNode(id: self.strokeIDCount)
            } else {
                let lastPoint = self.testingPoints.last
                let distance = Point.distanceBetween(pointA: point, pointB: lastPoint!)
                
                if distance > self.pointsThreshold {
                    self.testingPoints.append(point)
                    addInterestNode(id: self.strokeIDCount)
                }
            }
        }
    }
    
    private func addInterestNode(id: Int) {
        if interestNodePositions[id] == nil {interestNodePositions[id] = []}
        
        guard self.startNode != nil else {return}
        let pointerNode = Service.shared.getPointerNode(inView: self.arView)
        let target = Service.shared.transformPosition(originNode: self.startNode!, targetNode: pointerNode!)
        interestNodePositions[id]?.append(target)
    }

    
    // called by gesture recognizer
    @objc
    func tapHandler(gesture: UILongPressGestureRecognizer) {
        
        // handle touch down and touch up events separately
        if gesture.state == .began {
            screenTouchDown()
        } else if gesture.state == .ended {
            screenTouchUp()
        }
    }
    
    @objc
    func screenTouchDown() {
        screenDown = true
        if !testingMode {
            templatePoints.append([])
        }
        
        startNode = Service.shared.getPointerNode(inView: self.arView)
    }
    
    @objc
    func screenTouchUp() {
        screenDown = false
        
        if testingMode {
            guard let shapes = templateShapes else {return}
            let shape = Shape(points: self.testingPoints, type: .test)
            
            let resultType = QPointCloudRecognizer.classify(inputShape: shape, templateSet: shapes)
            self.typeString = resultType.rawValue
            
            let target = Shape(points: self.testingPoints, type: resultType)
            self.hideDots()
            
            add3DShapeToScene(templateSet: shapes, targetShape: target, strokeId: strokeIDCount)
            
            self.testingPoints = []
        } else {
            
            let latestPoints = templatePoints.filter({$0.count != 0}).last
            guard latestPoints!.count > 3 else {return}
            
            let latestShape = Shape(points: latestPoints!, type: self.currentType)
            if templateShapes == nil {
                templateShapes = []
            }
            
            
            // make sure there are enough sample points for configuring shapes
            switch latestShape.type {
            case .rectangle, .triangle:
                guard latestShape.originalPoints.count >= 15 else {return}
                break
            default:
                guard latestShape.originalPoints.count >= 3 else {return}
            }
            
            self.hideDots()
            
            templateShapes?.append(latestShape)
            guard let shapes = templateShapes else {return}
            
            add3DShapeToScene(templateSet: shapes, targetShape: latestShape, strokeId: strokeIDCount)
            
            Service.shared.saveShapeToFile(shape: templateShapes)
        }
        
        startNode = nil
    }
}

//MARK: - SCNNode actions here
extension ARSceneViewController {
    
    func addSphere() {
        let sphere = SCNNode()
        sphere.name = "penNode"
        sphere.geometry = SCNSphere(radius: 0.0015)
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.3)
        
        sphere.runAction(.fadeOut(duration: 4))
        sphere.runAction(.scale(to: 0, duration: 4))
        
        guard let startNode = self.startNode else {return}
        
        let position = Service.shared.to2D(originNode: startNode, inView: self.arView)
        
        self.addPoint(pointPos: position)
        
        Service.shared.addNode(sphere, toNode: self.scene.rootNode, inView: self.arView, cameraRelativePosition: self.cameraRelativePosition)
        
    }
    
    public func add3DShapeToScene(templateSet shapes: [Shape], targetShape shape: Shape, strokeId: Int) {
        let type = QPointCloudRecognizer.classify(inputShape: shape, templateSet: shapes)
        let count = shapes.filter({$0.type == type}).count - 1
        infoLabel.text = testingMode ? "This is a \(type)" : "\(type):\(count) added"
        Service.shared.fadeViewInThenOut(view: infoLabel, delay: 0.1)
        log.debug(type)
        
        let currentStroke = strokeId
        
        let pointerNode = Service.shared.getPointerNode(inView: self.arView)!
        let centerNode = Service.shared.getShapeCenterNode(originNode: startNode!, nodePositions: self.interestNodePositions[strokeId]!, targetNode: pointerNode)
        
        if let node = Service.shared.get3DShapeNode(forShape: shape, nodePositions:
            
            self.interestNodePositions[currentStroke]!) {
            
            if shape.type == .line {
                let target = node as! Line
                node.eulerAngles.z -= target.angle
            }
            centerNode.childNodes.first?.addChildNode(node)
            Service.shared.addNode(centerNode, toNode: self.scene.rootNode, inView: self.arView, cameraRelativePosition: self.cameraRelativePosition)
            
            let shouldSetHeightlighted = Float.random(in: 0 ... 1)
            if shouldSetHeightlighted <= 0.3 {
                centerNode.setHighlighted()
            }
        }
        
        strokeIDCount += 1
    }
    
    
    public func hideDots() {
        let dots = self.scene.rootNode.childNodes.filter({$0.name == "penNode"})
        dots.forEach { (dot) in
            DispatchQueue.main.async {
                dot.removeFromParentNode()
            }
        }
    }
}
