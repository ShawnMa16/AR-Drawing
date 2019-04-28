//
//  Point.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/7/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit

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

extension Point {
    static func distanceBetween(pointA: Point, pointB: Point) -> CGFloat {
        let xDist = pointA.x - pointB.x
        let yDist = pointA.y - pointB.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    func dotProduct(point: Point) -> Float {
        return self.x * point.x + self.y * point.y
    }
    
    func crossProduct(point: Point) -> Float {
        return self.x * point.y - self.y * point.x
    }
}

/**
 * Subtracts two Points as vectors and returns the result as a new Points.
 */

func - (left: Point, right: Point) -> Point {
    var result = Point(x: left.x - right.x, y: left.y - right.y, strokeID:  -1)
    result.intX = left.intX - right.intX
    result.intY = left.intY - right.intY
    return result
}

/**
 * Decrements a Point with the value of another.
 */
func -= (left: inout Point, right: Point) {
    left = left - right
}

/**
 Angle between line(PointA - PointB) to (0.01, 0)
 */

func PointAngle(pointA: Point, pointB: Point) -> Float {
    let fixedPoint = Point(x: 0.01, y: 0, strokeID: -1)
    
    let vector = pointA - pointB
    let dot = vector.dotProduct(point: fixedPoint)
    let cross = vector.crossProduct(point: fixedPoint)
    
    let angle = atan2(cross, dot)
    return angle
}

