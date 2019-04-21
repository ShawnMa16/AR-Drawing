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

        let tube = SCNTube(innerRadius: radius, outerRadius: (radius + 0.001), height: 0.001)        
        tube.firstMaterial?.diffuse.contents = UIColor.blue

        let node = SCNNode(geometry: tube)
        
        // roate the node to face the camera

        node.rotation = SCNVector4Make(1, 0, 0, .pi / 2)
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
