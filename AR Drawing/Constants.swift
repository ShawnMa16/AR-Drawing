//
//  Constants.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/24/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Constants {
    static let shared = Constants()

    public let cameraRelativePosition = SCNVector3(0, 0, -0.1)
    
    public let black = UIColor.black
    public var stroke: CGFloat {get {return CGFloat.random(in: 0 ... 0.002)}}
    
    
    private let colors: [UIColor?] = [
        UIColor.init(hexString: "#3C1856"), UIColor.init(hexString: "#3362AE"),
        UIColor.init(hexString: "#AACABF"), UIColor.init(hexString: "#809FCD"),
        UIColor.init(hexString: "#DCBE2B"), UIColor.init(hexString: "#E57F6A"),
        UIColor.init(hexString: "#87ADC7"), UIColor.init(hexString: "#355D1A"),
        UIColor.init(hexString: "#BE052C"), UIColor.init(hexString: "#6F4D98"),
        UIColor.init(hexString: "#767F6E"), UIColor.init(hexString: "#2D297F"),
        UIColor.init(hexString: "#BFA030"), UIColor.init(hexString: "#6D030D"),
        UIColor.init(hexString: "#795BA5"), UIColor.init(hexString: "#FFB1AF"),
        UIColor.init(hexString: "#D14854"), UIColor.init(hexString: "#B4BF5E"),
        UIColor.init(hexString: "#23518C"), UIColor.init(hexString: "#8B8795"),
        UIColor.init(hexString: "#B2889C"), UIColor.init(hexString: "#BB6C1B"),
        UIColor.init(hexString: "#1B4E3B"), UIColor.init(hexString: "#80455E"),
        UIColor.init(hexString: "#4A4180")
    ]
    
    public var randomColor: UIColor {
        get {
            let random = colors.randomElement()! ?? UIColor.white
            let randomAlpha = CGFloat.random(in: 0.5 ... 0.8)
            return random.withAlphaComponent(randomAlpha)
        }
    }
}
