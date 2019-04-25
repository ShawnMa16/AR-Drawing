//
//  Constants.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/24/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    private let blue = UIColor.blue.withAlphaComponent(0.3)
    private let orange = UIColor.orange.withAlphaComponent(0.3)
    
    public let black = UIColor.black
    public var stroke: CGFloat {get {return CGFloat.random(in: 0 ... 0.002)}}
    
    static let shared = Constants()
    
    private let colors: [UIColor]
    
    public var randomColor: UIColor {
        get {
            return colors.randomElement() ?? UIColor.white
        }
    }
    
    init() {
        colors = [blue, orange]
    }
}
