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
        
        for child in self.childNodes {
            child.setHighlighted()
        }
    }
    
    /// Creates A Pulsing Animation On An Infinite Loop
    ///
    /// - Parameter duration: TimeInterval
    func highlightNodeWithDurarion(_ duration: TimeInterval){
        
        //1. Create An SCNAction Which Emmits A Red Colour Over The Passed Duration Parameter
        let highlightAction = SCNAction.customAction(duration: duration) { (node, elapsedTime) in
            //Color: Gold
            let color = UIColor(red: elapsedTime/CGFloat(duration),
                                green: elapsedTime/CGFloat(duration) * (215/255),
                                blue: 0, alpha: 0.8)
            let currentMaterial = self.geometry?.firstMaterial
            currentMaterial?.emission.contents = color
            
        }
        
        //2. Create An SCNAction Which Removes The Red Emissio Colour Over The Passed Duration Parameter
        let unHighlightAction = SCNAction.customAction(duration: duration) { (node, elapsedTime) in
            let color = UIColor(red: CGFloat(1) - elapsedTime/CGFloat(duration),
                                green: CGFloat(1) - elapsedTime/CGFloat(duration) * (215/255),
                                blue: 0, alpha: 0.8)
            let currentMaterial = self.geometry?.firstMaterial
            currentMaterial?.emission.contents = color
            
        }
        
        //3. Create An SCNAction Sequence Which Runs The Actions
        let pulseSequence = SCNAction.sequence([highlightAction, unHighlightAction])
        
        //4. Set The Loop As Infinitie
        let infiniteLoop = SCNAction.repeatForever(pulseSequence)
        
        //5. Run The Action
        self.runAction(infiniteLoop)
    }
}
