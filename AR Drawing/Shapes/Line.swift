//
//  Line.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/20/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class Line: SCNNode {
    
    public var angle: Float
    
    init(height: CGFloat, angle: Float) {
        self.angle = angle

        super.init()
        
        let radius = CGFloat.random(in: 0.0001 ... 0.001)
        
        let shape = SCNCylinder(radius: radius, height: height)
        
        shape.firstMaterial?.diffuse.contents = UIColor.black

        let node = SCNNode(geometry: shape)
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
