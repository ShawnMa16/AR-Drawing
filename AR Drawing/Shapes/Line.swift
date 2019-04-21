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
    
    init(height: CGFloat) {
        super.init()
        
        let shape = SCNCylinder(radius: 0.001, height: height)
        
        shape.firstMaterial?.diffuse.contents = UIColor.red

        let node = SCNNode(geometry: shape)
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
