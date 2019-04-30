//
//  Circle.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/16/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class Circle: SCNNode {
    
    var centerNode: SCNNode?
    
    init(radius: CGFloat) {
        super.init()

        let stroke = Constants.shared.stroke
        let torus = SCNTorus(ringRadius: radius, pipeRadius: stroke)
        torus.firstMaterial?.diffuse.contents = Constants.shared.black
        // control the roundness of the torus
        torus.ringSegmentCount = 999
        
        let node = SCNNode(geometry: torus)
        
        let plane = SCNPlane(width: radius * 2, height: radius * 2)
        plane.cornerRadius = radius * 2
        plane.firstMaterial?.diffuse.contents = Constants.shared.randomColor
        plane.firstMaterial?.isDoubleSided = true
        let planeNode = SCNNode(geometry: plane)
        
        // roate the node to face the camera
        node.rotation = SCNVector4Make(1, 0, 0, .pi / 2)
        
        self.addChildNode(node)
        self.addChildNode(planeNode)
        
        if radius > 0.05 {
            if let action = Constants.shared.nodeBreathingAction {
                planeNode.runAction(.repeatForever(action))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
