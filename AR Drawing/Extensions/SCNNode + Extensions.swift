//
//  SCNNode + Extensions.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/26/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    func setHighlighted( _ highlighted : Bool = true, _ highlightedBitMask : Int = 3 ) {
        categoryBitMask = highlightedBitMask
        
        //for child in self.childNodes {
        //    child.setHighlighted()
        //}
    }
}
