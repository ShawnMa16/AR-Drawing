//
//  Rectangle.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/24/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

class Rectangle: SCNNode {
    init(width: CGFloat, height: CGFloat) {
        super.init()
        let stroke = Constants.shared.stroke
        let strokeBezierPath = UIBezierPath()
        strokeBezierPath.lineWidth = stroke
        
        strokeBezierPath.move(to: .zero)
        strokeBezierPath.addLine(to: CGPoint(x: width, y: 0))
        strokeBezierPath.addLine(to: CGPoint(x: width, y: height))
        strokeBezierPath.addLine(to: CGPoint(x: 0.0, y: height))
        strokeBezierPath.addLine(to: CGPoint(x: 0, y: 0))
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
        
        // fill the rectangle with a SCNPlane
        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.diffuse.contents = Constants.shared.randomColor
        let planeNode = SCNNode(geometry: plane)
        
        node.position.x = Float(-width / 2 )
        node.position.y = Float(-height / 2)

        self.addChildNode(node)
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
