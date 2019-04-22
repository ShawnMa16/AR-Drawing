//
//  Triangle.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/21/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Trianlge: SCNNode {
    init(points: [Point]) {
        super.init()
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: CGFloat(points[0].x), y: CGFloat(points[0].y)))
        bezierPath.addLine(to: CGPoint(x: CGFloat(points[1].x), y: CGFloat(points[1].y)))
        bezierPath.addLine(to: CGPoint(x: CGFloat(points[2].x), y: CGFloat(points[2].y)))
        bezierPath.close()
        
        let shape = SCNShape(path: bezierPath, extrusionDepth: 0.001)
        shape.materials.first?.diffuse.contents = UIColor.orange
        let node = SCNNode(geometry: shape)
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
