//
//  HalfCircle.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/26/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class HalfCircle: SCNNode {
    
    init(lineLength: CGFloat) {
        super.init()
        
        log.debug(lineLength)
        let length = lineLength * 100
        let centerPoint = CGPoint(x: 0, y: -length / 4)
        let stroke = Constants.shared.stroke
        let strokeBezierPath = UIBezierPath()
        strokeBezierPath.lineWidth = stroke
        strokeBezierPath.flatness = 0
        
        strokeBezierPath.move(to: CGPoint(x: -length / 2, y: -length / 4))

        strokeBezierPath.addArc(withCenter: centerPoint, radius: length / 2, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        
        strokeBezierPath.close()
        
        let shape = SCNShape(path: strokeBezierPath, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = Constants.shared.randomColor
        
        let node = SCNNode(geometry: shape)

        node.scale = SCNVector3(0.01, 0.01, 0.01)
        node.eulerAngles.z += Float.pi / 2
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
