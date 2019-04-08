//
//  Geometry.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/7/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation

class Geometry {
    public static func sqrEuclideanDistance(pointA: Point, pointB: Point) -> Float {
        return (pointA.x - pointB.x) * (pointA.x - pointB.x) + (pointA.y - pointB.y) * (pointA.y - pointB.y)
    }
    
    public static func euclideanDistance(pointA: Point, pointB: Point) -> Float {
        return sqrtf(sqrEuclideanDistance(pointA: pointA, pointB: pointB))
    }
}
