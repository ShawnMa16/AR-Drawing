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
    
    init(startPoint: SCNVector3, endPoint: SCNVector3) {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
