//
//  Service.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/9/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import ARKit

enum ShapeType: String {
    typealias RawValue = String
    case circle, rectangle, line, halfCircle, triangle
    case test
}

class Service {
    
    let cameraRelativePosition = Constants.shared.cameraRelativePosition
    
    static let shared = Service()
    
    public let testPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0.05, height: 0.05))
    
    public func getFirstNode(originNode: SCNNode, nodePositions: [SCNVector3], targetNode: SCNNode) -> SCNNode {
        let firstNode = SCNVector3FarthestPoints(positions: nodePositions).first
        let node = getNode(originNode: originNode, targetPosition: firstNode!, targetNode: targetNode)
        
        let rootNode = SCNNode()
        rootNode.addChildNode(node)
        return rootNode
    }
    
    public func getShapeCenterNode(originNode: SCNNode, nodePositions: [SCNVector3], targetNode: SCNNode) -> SCNNode {

        let centerPosition = SCNVector3Center(positions: nodePositions)
        
        // pivoted child node
        let node = getNode(originNode: originNode, targetPosition: centerPosition, targetNode: targetNode)
        let rootNode = SCNNode()
        rootNode.addChildNode(node)
        return rootNode
    }
    
    public func getNode(originNode: SCNNode, targetPosition: SCNVector3, targetNode: SCNNode) -> SCNNode {
        // pivoted child node
        let node = SCNNode()
        
        // convert centered position based on originNode(plane origin) and pointer
        
        // As the center position was transformed based on originNode(plane origin),
        // we need to tranform back to it
        node.position = targetNode.convertPosition(targetPosition, from: originNode)
        return node
    }

    public func to2D(originNode: SCNNode, inView: ARSCNView) -> (x: Float, y: Float) {
        let nodePos = getPointerNode(inView: inView)!
        let position = transformPosition(originNode: originNode, targetNode: nodePos)
        
        // some how the actual x and y for point is pos.y and -pos.x
        return (position.y, -position.x)
    }
    
    public func transformPosition(originNode: SCNNode, targetNode: SCNNode) -> SCNVector3 {
        return targetNode.convertPosition(SCNVector3Make(0, 0, 0), to: originNode)
    }

    public func getPointerNode(inView: ARSCNView) -> SCNNode? {
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
    
    public func addNode(_ node: SCNNode, toNode: SCNNode, inView: ARSCNView, cameraRelativePosition: SCNVector3) {
        
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
    
    /**
     Fade in a UIView in 1.5s and show it for a certain than fade it out in 1.5s
     - Parameter view: UIView that needed to be faded in and out
     - Parameter delay: TimeInterval you want to stay between fade in and out
     */
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        
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
    
    func get3DShapeNode(forShape shape: Shape, nodePositions: [SCNVector3]) -> SCNNode? {
        
        switch shape.type {
        case .circle:
            guard let radius = computeCircle(shape: shape) else {return nil}
            return Circle(radius: radius)
        case .line:
            let heightAndLine = computeLine(shape: shape)
            guard let height = heightAndLine.lineHeight else {return nil}
            guard let angle = heightAndLine.angle else {return nil}
            return Line(height: height, angle: angle)
        case .triangle:
            let pointsAndAngle = farthestPointsAndAngle(center: shape.center!, points: shape.originalPoints, type: shape.type)
            guard let points = pointsAndAngle.points else {return nil}
            guard let angle = pointsAndAngle.angle else {return nil}
            
            return Trianlge(points: points, angle: angle)
        case .rectangle:
            let widthAndHeight = computeRectangle(shape: shape)
            guard let halfWidth = widthAndHeight.halfWidth else {return nil}
            guard let halfHeight = widthAndHeight.halfHeight else {return nil}
            return Rectangle(width: halfWidth * 2, height: halfHeight * 2)
        case .halfCircle:
            guard let length = computeHalfCircle(shape: shape) else {return nil}
            return HalfCircle(lineLength: length)
         default:
            return SCNNode()
        }
    }

    
}

extension Service {
    
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
        
    }
    
    private func computeHalfCircle(shape: Shape) -> CGFloat? {
        let pointsAndAngle = farthestPointsAndAngle(center: shape.center!, points: shape.originalPoints, type: shape.type)
        guard let points = pointsAndAngle.points else {return nil}
        guard let angle = pointsAndAngle.angle else {return nil}
        
        let dist = Point.distanceBetween(pointA: points[0], pointB: points[1])
        log.debug(dist)
        return dist
    }
    
    /**
     Compute rectangle
     - Parameter shape: A Shape object
     - Returns: halfWidth and halfHeight
     */
    private func computeRectangle(shape: Shape) -> (halfWidth: CGFloat?, halfHeight: CGFloat?) {
        let rectAndAngle = farthestPointsAndAngle(center: shape.center!, points: shape.originalPoints, type: shape.type)
        guard let points = rectAndAngle.points else {return (nil, nil)}
        guard let angle = rectAndAngle.angle else {return (nil, nil)}
        
        let shortDist = Point.distanceBetween(pointA: shape.center!, pointB: points[1])
        let longDist = Point.distanceBetween(pointA: shape.center!, pointB: points[0])
        
        // if |angle * 180 / Float.pi| > 45, means width < heigt
        log.debug(angle * 180 / Float.pi)
        let angleIn180 = abs(angle * 180 / Float.pi)
        let halfWidth = angleIn180 >= 45 ? longDist : shortDist
        let halfHeight = angleIn180 >= 45 ? shortDist : longDist
        
        return (halfWidth, halfHeight)
    }
    
    /**
     Compute line
     - Parameter shape: A Shape object
     - Returns: lineHeight and angle
     */
    private func computeLine(shape: Shape) -> (lineHeight: CGFloat?, angle: Float?) {
        let pointsAndAngle = self.farthestPointsAndAngle(center: shape.center!, points: shape.originalPoints, type: .line)
        let distance = Point.distanceBetween(pointA: pointsAndAngle.points![0], pointB: pointsAndAngle.points![1])
        let angle = pointsAndAngle.angle
        return (distance, angle)
    }
    
    
    /**
     Compute circle
     - Parameter shape: A Shape object
     - Returns: circle's radius
     */
    private func computeCircle(shape: Shape) -> CGFloat? {
        guard let center = shape.center else {return nil}
        guard let firstPoint = farthestPointsAndAngle(center: center, points: shape.originalPoints, type: .circle).points?.first else {return nil}
        
        let radius = Point.distanceBetween(pointA: firstPoint, pointB: center)
        
        return radius
    }
    
    /**
     Sort the farthest points distance from each point to the center Point
     - Parameter center: Center of the Points
     - Parameter points: Points for sorting
     - Parameter type: Type of the shape, for returning different result
     - Returns: Sorted farthest points and angle between line(PointA - PointB) to (0.01, 0)
     */
    func farthestPointsAndAngle(center: Point, points: [Point], type: ShapeType) -> (points: [Point]?, angle: Float?) {
        let center = center
        let sorted = points.sorted { (pointA, pointB) -> Bool in
            let distA = Point.distanceBetween(pointA: pointA, pointB: center)
            let distB = Point.distanceBetween(pointA: pointB, pointB: center)
            
            return distA > distB
        }
        
        switch type {
        case .triangle:
            // get the farthest three points to form a triangle
            let tri = sorted[0 ..< 3]
            let angle = PointAngle(pointA: tri[1], pointB: tri[0])
            return (Array(tri), angle)
        case .line, .halfCircle:
            // get the farthest two points to form a line
            let line = sorted[0 ..< 2]
            let angle = PointAngle(pointA: line[1], pointB: line[0])
            return (Array(line), angle)
        case .circle:
            // get the first point to form a circle
            let point = sorted.first
            return ([point!], nil)
        case .rectangle:
            // get the closest and farthest points for calculating width and height for rectangle
            let points = [sorted.first!, sorted.last!]
            let angle = PointAngle(pointA: points[1], pointB: Point(x: 0, y: 0, strokeID: -1))
            return (points, angle)
        default:
            return (nil, nil)
        }
    }
}
