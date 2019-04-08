//
//  Point.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/7/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation

struct Point {
    public var x: Float
    public var y: Float
    
    public var strokeID: Int
    public var intX: Int
    public var intY: Int
    
    init(x: Float, y: Float, strokeID: Int) {
        self.x = x
        self.y = y
        self.strokeID = strokeID
        self.intX = 0
        self.intY = 0
    }
    
    mutating func toInt(floatX: Float, floatY: Float) {
        self.intX = Int(floatX)
        self.intY = Int(floatY)
    }
}
