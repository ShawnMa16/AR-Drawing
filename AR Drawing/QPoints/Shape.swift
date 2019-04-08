//
//  Shape.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/7/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation

struct Shape {
    public var points: [Point]
    public var name: String = ""
    
    private let SAMPLING_RESOLUTION: Int = 32                            // default number of points on the gesture path
    private let MAX_INT_COORDINATES: Int = 1024                           // $Q only: each point has two additional x and y integer coordinates in the interval [0..MAX_INT_COORDINATES-1] used to operate the LUT table efficiently (O(1))
    public let LUT_SIZE: Int = 64                                        // $Q only: the default size of the lookup table is 64 x 64
    public let LUT_SCALE_FACTOR: Int
    
    public var LUT: [[Int]] = [[]]        // lookup table
    
    private func scale(points: [Point]) -> [Point] {
        var minX = Float.greatestFiniteMagnitude,
        minY = Float.greatestFiniteMagnitude,
        maxX = Float.leastNonzeroMagnitude,
        maxY = Float.leastNonzeroMagnitude
        
        points.forEach { (point) in
            if (minX > point.x) {minX = point.x}
            if (minY < point.y) {minY = point.y}
            if (maxX < point.x) {maxX = point.x}
            if (maxY < point.y) {maxY = point.y}
        }
        
        let scale = max(maxX - minX, maxY - minY)
        
        let newPoints = points.map { (point) -> Point in
            return Point(x: (point.x - minX) / scale, y: (point.y - minY) / scale, strokeID: point.strokeID)
        }
        
        return newPoints
    }
    
    /// Computes the centroid for an array of points
    private func centroid(points: [Point]) -> Point {
        var cx: Float = 0, cy: Float = 0;
        cx = points.reduce(0, { (result, point) -> Float in
            return result + point.x
        })
        cy = points.reduce(0, { (result, point) -> Float in
            return result + point.y
        })
        return Point(x: cx / Float(points.count), y: cy / Float(points.count), strokeID: 0)
    }
    
    /// Computes the path length for an array of points
    private func pathLength(points: [Point]) -> Float {
        var length:Float = 0
        for i in 1 ..< points.count {
            if points[i].strokeID == points[i - 1].strokeID {
                length += Geometry.euclideanDistance(pointA: points[i - 1], pointB: points[i])
            }
        }
        return length
    }
    
    /// Scales point coordinates to the integer domain [0..MAXINT-1] x [0..MAXINT-1]
    private mutating func transformCoordinatesToIntegers() {
        
        for i in 0 ..< self.points.count {
            let floatX = (self.points[i].x + 1.0) / 2.0 * Float(MAX_INT_COORDINATES - 1)
            let floatY = (self.points[i].y + 1.0) / 2.0 * Float(MAX_INT_COORDINATES - 1)
            self.points[i].toInt(floatX: floatX, floatY: floatY)
        }
    }
    
    /// Translates the array of points by p
    private func translateTo(points: [Point], p: Point) -> [Point] {
        return points.map({ (point) -> Point in
            return Point(x: point.x - p.x, y: point.y - p.y, strokeID: point.strokeID)
        })
    }
    
    /// Resamples the array of points into n equally-distanced points
    public func resample(points: [Point], n: Int) -> [Point] {
        var result: [Point?] = [Point?](repeating: nil, count: points.count)
        result[0] = points[0]
        
        var numPoints:Int = 1
        let I: Float = pathLength(points: points) / Float(n - 1)
        var D: Float = 0
        
        for i in 1 ..< points.count {
            if points[i].strokeID == points[i - 1].strokeID {
                
                var d = Geometry.euclideanDistance(pointA: points[i - 1], pointB: points[i])
                if D + d >= I {
                    var firstPoint = points[i - 1]
                    
                    while D + d >= I {
                        
                        // add interpolated point
                        let maxNum = max((I - D) / d, 0.0)
                        let t = min(maxNum, 1.0)
//                        if t == nil {t = 0.5}
                        result[numPoints] = Point(
                            x: (1.0 - t) * firstPoint.x + t * points[i].x,
                            y: (1.0 - t) * firstPoint.y + t * points[i].y,
                            strokeID: points[i].strokeID)
                        numPoints += 1
                        
                        // update partial length
                        d = D + d - I;
                        D = 0;
                        firstPoint = result[numPoints - 1]!
                    }
                    D = d
                } else { D += d}

            }
        }
        if numPoints == n - 1 {
            result[numPoints] = Point(x: points[points.count - 1].x, y: points[points.count - 1].y, strokeID: points[points.count - 1].strokeID)
            numPoints += 1
        }
        return result as! [Point]
    }
    
    private mutating func constructLUT() {
        for i in 0 ..< LUT_SIZE {
            LUT.append([])
            for j in 0 ..< LUT_SIZE {
                var minDistance = Int.max
                var indexMin = -1
                
                for t in 0 ..< self.points.count {
                    let row = points[t].intX / LUT_SCALE_FACTOR
                    let col = points[t].intY / LUT_SCALE_FACTOR
                    let dist = (row - i) * (row - i) + (col - j) * (col - j)
                    if dist < minDistance {
                        minDistance = dist
                        indexMin = t
                    }
                }
                LUT[i].append(indexMin)
            }
        }
    }
    
    init(points: [Point], name: String = "") {
        
        self.points = []
        self.name = name
        
        self.LUT_SCALE_FACTOR = MAX_INT_COORDINATES / LUT_SIZE
        
        let scaled = scale(points: points)
    }
    
}
