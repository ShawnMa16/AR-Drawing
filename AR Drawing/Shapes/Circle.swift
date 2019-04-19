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
    
    private var shape: SCNShape?
    var centerNode: SCNNode?
    
    init(path: UIBezierPath) {
        super.init()
        
        let strokeBezierPath = UIBezierPath()
        strokeBezierPath.lineWidth = 0.01
        strokeBezierPath.move(to: CGPoint.zero)
        strokeBezierPath.addLine(to: CGPoint(x: 0.1, y: 0))
        strokeBezierPath.addLine(to: CGPoint(x: 0.1, y: 0.1))
        strokeBezierPath.addLine(to: CGPoint(x: 0.0, y: 0.1))
        strokeBezierPath.addLine(to: CGPoint(x: 0, y: 0))
        strokeBezierPath.close()
        let cgPath = strokeBezierPath.cgPath.copy(
            strokingWithWidth: strokeBezierPath.lineWidth,
            lineCap: strokeBezierPath.lineCapStyle,
            lineJoin: strokeBezierPath.lineJoinStyle,
            miterLimit: strokeBezierPath.miterLimit)
        
        let bezierPath = UIBezierPath(cgPath: cgPath)
        let shape = SCNShape(path: bezierPath, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode(geometry: shape)
        
        self.addChildNode(node)
////        path.flatness = 0.001
//        path.flatness = 0
//        shape = SCNShape(path: path, extrusionDepth: 0.01)
//        shape?.firstMaterial?.diffuse.contents = SKColor.blue
////        shape?.firstMaterial?.fillMode = .lines
////
////        let radius : CGFloat = 1.0
////        let outerPath = UIBezierPath(ovalIn: CGRect(x: -radius, y: -radius, width: 2 *  radius, height: 2 * radius))
////
////        let material = SCNMaterial()
////        material.diffuse.contents = UIColor.blue
////        material.isDoubleSided = true
////        material.ambient.contents = UIColor.black
////        material.lightingModel = .constant
////        material.emission.contents = UIColor.blue
////
////        let shape = SCNShape(path: outerPath, extrusionDepth: 0.01)
////        shape.materials = [material]
//
//        let shapeNode = SCNNode(geometry: shape)
//
//        self.addChildNode(shapeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
