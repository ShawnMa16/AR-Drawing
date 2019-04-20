//
//  QPointCloudRecognizer.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/7/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation

class QPointCloudRecognizer {
    public static var useEarlyAbandoning: Bool = true
    public static var useLowerBounding: Bool = true
    
    /// Main function of the $Q recognizer.
    /// Classifies a candidate gesture against a set of templates.
    /// Returns the class of the closest neighbor in the template set.
    public static func classify(inputShape: Shape, templateSet: [Shape]) -> String {
        var minDistance = Float.greatestFiniteMagnitude
        var shapeClass = ""
        
        templateSet.forEach { (template) in
            let dist = greedyCloudMatch(shape1: inputShape, shape2: template, minSoFar: minDistance)
            if dist < minDistance {
                minDistance = dist
                shapeClass = template.name
            }
        }
        
        return shapeClass
    }
    
    /// Implements greedy search for a minimum-distance matching between two point clouds.
    /// Implements Early Abandoning and Lower Bounding (LUT) optimizations.
    private static func greedyCloudMatch(shape1: Shape, shape2: Shape, minSoFar: Float) -> Float {
        var _minSoFar = minSoFar
        let n = shape1.points.count         // the two clouds should have the same number of points by now
        let eps = 0.5       // controls the number of greedy search trials (eps is in [0..1])
        let step = Int(floor(pow(Double(n), 1.0 - eps)))
        
        if self.useLowerBounding {
            let LB1 = computeLowerBound(points1: shape1.points, points2: shape2.points, LUT: shape2.LUT, step: step) // direction of matching: shape1 --> shape2
            let LB2 = computeLowerBound(points1: shape2.points, points2: shape1.points, LUT: shape1.LUT, step: step) // direction of matching: shape2 --> shape1
            
            var indexLB = 0
            for i in stride(from: 0, to: n, by: step) {
                if (LB1[indexLB] < _minSoFar) {_minSoFar = min(_minSoFar, cloudDistance(points1: shape1.points, points2: shape2.points, startIndex: i, minSoFar: _minSoFar))}
                if (LB2[indexLB] < _minSoFar) {_minSoFar = min(_minSoFar, cloudDistance(points1: shape2.points, points2: shape1.points, startIndex: i, minSoFar: _minSoFar))}
                indexLB += 1
            }
        } else {
            for i in stride(from: 0, to: n, by: step) {
                _minSoFar = min(_minSoFar, cloudDistance(points1: shape1.points, points2: shape2.points, startIndex: i, minSoFar: _minSoFar))
                _minSoFar = min(_minSoFar, cloudDistance(points1: shape2.points, points2: shape1.points, startIndex: i, minSoFar: _minSoFar))
            }
        }
        
        return _minSoFar
    }
    
    /// Computes lower bounds for each starting point and the direction of matching from points1 to points2
    private static func computeLowerBound(points1: [Point], points2: [Point], LUT: [[Int]], step: Int) -> [Float] {
        let n = points1.count
        var LB: [Float?] = [Float?](repeating: nil, count: n / step + 1)
        LB[0] = 0
        
        var SAT: [Float?] = [Float?](repeating: nil, count: n)
        
        for i in 0 ..< n {
            let index = LUT[points1[i].intY / Shape.LUT_SCALE_FACTOR][points1[i].intX / Shape.LUT_SCALE_FACTOR]
            let dist = Geometry.sqrEuclideanDistance(pointA: points1[i], pointB: points2[index])
            SAT[i] = (i == 0) ? dist : SAT[i - 1]! + dist
            LB[0]! += Float(n - i) * dist
        }
        
        var indexLB = 1
        for i in stride(from: step, to: n, by: step) {
            let nextNum = Float(i) * SAT[n - 1]! - Float(n) * SAT[i - 1]!
            LB[indexLB] = LB[0]! + nextNum
            indexLB += 1
        }
        
        return LB as! [Float]
    }
    
    /// Computes the distance between two point clouds by performing a minimum-distance greedy matching
    /// starting with point startIndex
    public static func cloudDistance(points1: [Point], points2: [Point], startIndex: Int, minSoFar: Float) -> Float {
        let n = points1.count                // the two point clouds should have the same number of points by now

        var indexesNotMatched = points1.enumerated().map { (i, _) -> Int in
            return i
        } // stores point indexes for points from the 2nd cloud that haven't been matched yet
        
        var sum: Float = 0             // computes the sum of distances between matched points (i.e., the distance between the two clouds)

        var i: Int = startIndex           // start matching with point startIndex from the 1st cloud
        
        var weight: Int = n             // implements weights, decreasing from n to 1
        
        var indexNotMatched: Int = 0      // indexes the indexesNotMatched[..] array of points from the 2nd cloud that are not matched yet
        
        repeat {
            var index = -1
            var minDistance: Float = Float.greatestFiniteMagnitude
            
            for j in indexNotMatched ..< n {
                let dist = Geometry.euclideanDistance(pointA: points1[i], pointB: points2[indexesNotMatched[j]])    // use the squared Euclidean distance
                if (dist < minDistance) {
                    minDistance = dist
                    index = j
                }
            }
            indexesNotMatched[index] = indexesNotMatched[indexNotMatched]  // point indexesNotMatched[index] of the 2nd cloud is now matched to point i of the 1st cloud
            sum += Float(weight) * minDistance           // weight each distance with a confidence coefficient that decreases from n to 1
            weight -= 1
            
            if (self.useEarlyAbandoning)
            {
                if (sum >= minSoFar) {return sum}       // implement early abandoning
            }
            
            i = (i + 1) % n                           // advance to the next point in the 1st cloud
            indexNotMatched += 1                         // update the number of points from the 2nd cloud that haven't been matched yet
        } while (i != startIndex)
        return sum
    }
}
