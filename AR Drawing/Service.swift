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
    
//    public static func to3D(startPoint: SCNVector3, inView: ARSCNView, point: Point) -> SCNVector3 {
//
//    }
    
    public static func to2D(startPoint: SCNVector3, inView: ARSCNView) -> (x: Float, y: Float) {
        
        let planePos = startPoint
        let normalizedVector = SCNVector3Make(0, 0, 1)
        
        let nodePos = getPointerPosition(inView: inView, cameraRelativePosition: self.cameraRelativePosition).pos - planePos
        let camPos = getPointerPosition(inView: inView, cameraRelativePosition: self.cameraRelativePosition).camPos - planePos

        let target = nodePos - planePos
        let dist = target * normalizedVector

        let x = (nodePos.x - camPos.x) * (dist.length() / nodePos.z) + camPos.x
        let y = (nodePos.y - camPos.y) * (dist.length() / nodePos.z) + camPos.y
        log.debug(x)
        log.debug(y)
        
        return (x, y)
    }
    
    public static func getPointerPosition(inView: ARSCNView, cameraRelativePosition: SCNVector3) -> (pos : SCNVector3, valid: Bool, camPos : SCNVector3) {
        
        guard let pointOfView = inView.pointOfView else { return (SCNVector3Zero, false, SCNVector3Zero) }
        
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        
        let pointerPosition = currentPositionOfCamera + cameraRelativePosition
        
        return (pointerPosition, true, currentPositionOfCamera)
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
//        guard let path = self.generatePath(forShape: shape) else {return nil}
        
        switch shape.name {
        case "circle":
            guard let radius = computeCircle(shape: shape) else {return nil}
            return Circle(radius: radius)
        case "line":
            guard let height = computeLine(shape: shape) else {return nil}
            return Line(height: height)
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
        guard let firstPoint = shape.originalPoints.first else {return nil}
        guard let lastPoint = shape.originalPoints.last else {return nil}
        
        let distance = Point.distanceBetween(pointA: firstPoint, pointB: lastPoint)
        return distance / 2
    }
    
    private static func computeCircle(shape: Shape) -> CGFloat? {
        guard let center = shape.center else {return nil}
        guard let firstPoint = shape.originalPoints.first else {return nil}
        log.info(center)
        log.info(firstPoint)
        
        let radius = Point.distanceBetween(pointA: firstPoint, pointB: center)
        log.debug(radius)
        
        return radius / 2
    }
}
