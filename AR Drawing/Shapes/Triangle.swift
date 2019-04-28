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
        
        let stroke = Constants.shared.stroke
        let strokeBezierPath = UIBezierPath()
        strokeBezierPath.lineWidth = stroke
        
        strokeBezierPath.move(to: CGPoint(x: CGFloat(points[0].x), y: CGFloat(points[0].y)))
        strokeBezierPath.addLine(to: CGPoint(x: CGFloat(points[1].x), y: CGFloat(points[1].y)))
        strokeBezierPath.addLine(to: CGPoint(x: CGFloat(points[2].x), y: CGFloat(points[2].y)))
        strokeBezierPath.close()
        
        let cgPath = strokeBezierPath.cgPath.copy(
            strokingWithWidth: strokeBezierPath.lineWidth,
            lineCap: strokeBezierPath.lineCapStyle,
            lineJoin: strokeBezierPath.lineJoinStyle,
            miterLimit: strokeBezierPath.miterLimit)
        
        let bezierPath = UIBezierPath(cgPath: cgPath)
        let shape = SCNShape(path: bezierPath, extrusionDepth: 0.001)
        shape.firstMaterial?.diffuse.contents = Constants.shared.black

        let node = SCNNode(geometry: shape)
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
