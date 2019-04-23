//
//  Service.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/9/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import ARKit

class Service: NSObject {
    
    public static let cameraRelativePosition = SCNVector3(0, 0, -0.1)
    
    public static let testPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0.05, height: 0.05))
    
    
    public static func getShapeCenterNodePosition(originNode: SCNNode, nodePositions: [SCNVector3], targetNode: SCNNode) -> SCNNode {

        let centerPosition = SCNVector3Center(positions: nodePositions)
        
        // pivoted child node
        let node = to3D(originNode: originNode, targetPosition: centerPosition, targetNode: targetNode)
        let rootNode = SCNNode()
        rootNode.addChildNode(node)
        return rootNode
    }
    
    private static func to3D(originNode: SCNNode, targetPosition: SCNVector3, targetNode: SCNNode) -> SCNNode{
        // pivoted child node
        let node = SCNNode()
        
        // convert centered position based on originNode(plane origin) and pointer
        
        // As the center position was transformed based on originNode(plane origin),
        // we need to tranform back to it
        node.position = targetNode.convertPosition(targetPosition, from: originNode)
        return node
    }
    
//    public static func to3D(startPoint: SCNVector3, interestPoint: Point, inView: ARSCNView) -> SCNNode {
//        let planePos = startPoint
//        let normalizedVector = SCNVector3Make(0, 0, 1)
//        let x = interestPoint.x, y = interestPoint.y
//        
//        
//        let camPos = getPointerPosition(inView: inView, cameraRelativePosition: self.cameraRelativePosition).camPos - planePos
//        let targetNode = SCNNode()
//        
//        
//        return targetNode
//    }
    
    
    // project the point to a 2D plane
//    public static func to2D(startPoint: SCNVector3, inView: ARSCNView) -> (x: Float, y: Float) {
//
//        let planeOrg = SCNVector3Make(0, 0, 0)
//        let normalizedVector = SCNVector3Make(0, 0, 1)
//
//        let nodePos = getPointerPosition(inView: inView, cameraRelativePosition: self.cameraRelativePosition).pos - startPoint
//        let camPos = getPointerPosition(inView: inView, cameraRelativePosition: self.cameraRelativePosition).camPos - startPoint
//
//
////        log.debug(nodePos)
////        log.debug(camPos - nodePos)
//
//        let target = nodePos - planeOrg
//        let dist = target * normalizedVector
//        let length = target.dot(vector: normalizedVector)
//        let projected = nodePos - dist * normalizedVector
//        log.debug(projected)
//
//        let x = (nodePos.x - camPos.x) * (length / nodePos.z) + camPos.x
//        let y = (nodePos.y - camPos.y) * (length / nodePos.z) + camPos.y
//        log.debug(x)
//
//        return (x, y)
//    }
    
    public static func to2D(originNode: SCNNode, inView: ARSCNView) -> (x: Float, y: Float) {
        let nodePos = getPointerNode(inView: inView)!
        let position = transformPosition(originNode: originNode, targetNode: nodePos)
        
        // some how the actual x and y for point is pos.y and -pos.x
        return (position.y, -position.x)
    }
    
    public static func transformPosition(originNode: SCNNode, targetNode: SCNNode) -> SCNVector3 {
        return targetNode.convertPosition(SCNVector3Make(0, 0, 0), to: originNode)
    }
    
//    public static func getPointerPosition(inView: ARSCNView, cameraRelativePosition: SCNVector3) -> (pos : SCNVector3, valid: Bool, camPos : SCNVector3) {
//        
//        guard let pointOfView = inView.pointOfView else { return (SCNVector3Zero, false, SCNVector3Zero) }
//        
//        let transform = pointOfView.transform
//        let orientation = SCNVector3(-transform.m31, -transform.m32, transform.m33)
//        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
//        let currentPositionOfCamera = orientation + location
//        
//        let pointerPosition = currentPositionOfCamera + cameraRelativePosition
//        
//        return (pointerPosition, true, currentPositionOfCamera)
//    }
    
    public static func getPointerNode(inView: ARSCNView) -> SCNNode? {
        guard let currentFrame = inView.session.currentFrame else { return nil }
        let node = SCNNode()
        
        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = cameraRelativePosition.x
        translationMatrix.columns.3.y = cameraRelativePosition.y
        translationMatrix.columns.3.z = cameraRelativePosition.z
        let modifiedMatrix = simd_mul(transform, translationMatrix)
        node.simdTransform = modifiedMatrix
        
        return node
    }
    
    public static func addNode(_ node: SCNNode, toNode: SCNNode, inView: ARSCNView, cameraRelativePosition: SCNVector3) {
        
        guard let currentFrame = inView.session.currentFrame else { return }
        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = cameraRelativePosition.x
        translationMatrix.columns.3.y = cameraRelativePosition.y
        translationMatrix.columns.3.z = cameraRelativePosition.z
        let modifiedMatrix = simd_mul(transform, translationMatrix)
        node.simdTransform = modifiedMatrix
        DispatchQueue.main.async {
            toNode.addChildNode(node)
        }
    }
    
    static func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 1.5
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                view.alpha = 0
            }, completion: nil)
        }
    }

}

//MARK:- 3D shapes go here
extension Service {
    
    static func get3DShapeNode(forShape shape: Shape) -> SCNNode? {
        
        switch shape.name {
        case "circle":
            guard let radius = computeCircle(shape: shape) else {return nil}
            return Circle(radius: radius)
        case "line":
            guard let height = computeLine(shape: shape) else {return nil}
            return Line(height: height)
        case "triangle":
            guard let points = farthestPoints(center: shape.center!, points: shape.originalPoints, type: "triangle") else {return nil}
            return Trianlge(points: points)
        default:
            return SCNNode()
        }
    }
    
//    private static func generatePath(forShape shape: Shape) -> UIBezierPath? {
//        switch shape.name {
//        case "circle":
//            return self.computeCircle(shape: shape)
//        case "line":
//            return self.computeLine(shape: shape)
//        default:
//            return nil
//        }
//    }
    
    private static func computeLine(shape: Shape) -> CGFloat? {
        let points = self.farthestPoints(center: shape.center!, points: shape.originalPoints, type: "line")
        let distance = Point.distanceBetween(pointA: points![0], pointB: points![1])
        
        return distance
    }
    
    private static func computeCircle(shape: Shape) -> CGFloat? {
        guard let center = shape.center else {return nil}
        guard let firstPoint = farthestPoints(center: center, points: shape.originalPoints, type: "circle")?.first else {return nil}
        log.info(center)
        log.info(firstPoint)
        
        let radius = Point.distanceBetween(pointA: firstPoint, pointB: center)
        log.debug(radius)
        
        return radius
    }
    
}

extension Service {
    
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
        
    }
    static func farthestPointsin3D(nodePositions: [SCNVector3]) {

        let centerPosition = SCNVector3Center(positions: nodePositions)
        
        let sorted = nodePositions.sorted { (nodeA, nodeB) -> Bool in
            let distA = SCNVector3Distance(vectorStart: nodeA, vectorEnd: centerPosition)
            let distB = SCNVector3Distance(vectorStart: nodeB, vectorEnd: centerPosition)
            
            return distA > distB
        }
    }
    
    static func farthestPoints(center: Point, points: [Point], type: String) -> [Point]? {
        let center = center
        let sorted = points.sorted { (pointA, pointB) -> Bool in
            let distA = Point.distanceBetween(pointA: pointA, pointB: center)
            let distB = Point.distanceBetween(pointA: pointB, pointB: center)
            
            return distA > distB
        }
        
        switch type {
        case "triangle":
            let tri = sorted[0 ..< 3]
            return Array(tri)
        case "line":
            let line = sorted[0 ..< 2]
            return Array(line)
        case "circle":
            let point = sorted.first
            return [point!]
        default:
            return nil
        }
    }
}
