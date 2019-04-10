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
    
    public static func to2D(startPoint: SCNVector3, inView: ARSCNView) -> (x: Float, y: Float) {
        let planePos = startPoint
        let camPos = getPointerPosition(inView: inView, cameraRelativePosition: self.cameraRelativePosition).camPos
        let nodePos = getPointerPosition(inView: inView, cameraRelativePosition: self.cameraRelativePosition).pos
        
        let f = (camPos - planePos).length()
        let x = (nodePos.x - camPos.x) * (f / nodePos.z) + camPos.x
        let y = (nodePos.y - camPos.y) * (f / nodePos.z) + camPos.y
        print(f)
        print(x , y)
        return (x + 1, y + 1)
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
}
