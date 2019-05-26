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
    
    public let cameraAccess: String = "camearAccess"
    
    public let appInfo: String = """
    AR Masters is an Augmented Reality experience that intends to describe spaces that lie beyond the normal range of sensual experience. When the world is your canvas, something magical happens, with the virtual lines you draw livened up to be colorful geometric shapes with different angles – lines, circles, semi-circles, and rectangles.

    Please see licenses in AR Master's settings. If you have any questions, feel free to contact us at iosxma@gmail.com. Thank you for the supporting!
    """
    
    public let privacy: String = """
    AR Masters uses the device’s rear camera to detect the space, and provides the function to record the screen and uses the microphone. The camera and microphone access can be toggled on and off at any time in your device’s settings.

    The camera videos are only used for the intended purposes. The live video feed from the rear camera is never stored or sent outside your device in any form. All data is stored on the device only for the duration of your current launch session. Every time you go back to home screen or close the app, the data is deleted. We don’t collect your information in any form, whether you are using the app or not.

    If you have any questions regarding privacy while using the app, please contact us at iosxma@gmail.com.
    """
    
    public let tagForInforView: Int = 10001
    public let tagForPrivacyView: Int = 10002

    public let cameraRelativePosition = SCNVector3(0, 0, -0.1)
    
    private let docsBaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    public let templateShapesURL: URL
    public let releaseMode: Bool = true
    public let black = UIColor.black
    public var stroke: CGFloat {get {return CGFloat.random(in: 0 ... 0.0008)}}
    
    public let jsonFileName: String = "shapes"
    
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

    public var randomRepeating: Int {
        get {return Int.random(in: 0 ... 5)}
    }
    
    public var buttonInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    public var nodeBlinkingAction: SCNAction {
        return .sequence([
            .wait(duration: 5.0),
            .fadeOpacity(to: 0.2, duration: 0.06),
            .fadeOpacity(to: 1.0, duration: 0.06),
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.2, duration: 0.06),
            .fadeOpacity(to: 1.0, duration: 0.06)
            ])
    }
    
    public var nodeBreathingAction: SCNAction? {
        let randomFloat = Float.random(in: 0 ..< 1)
        if randomFloat < 0.7 {
            return .sequence([
                .wait(duration: 5.0),
                .fadeOpacity(to: 0.5, duration: 0.8),
                .fadeOpacity(to: 1.0, duration: 2.0),
                .wait(duration: 0.25),
                .fadeOpacity(to: 0.5, duration: 0.8),
                .fadeOpacity(to: 1.0, duration: 2.0)
                ])
        }
        return nil
    }
    
    public var nodeScalingAction: SCNAction {
        return .sequence([
            .wait(duration: 5.0),
            .scale(to: 0.9, duration: 0.8),
            .scale(to: 1.0, duration: 2.0),
            .wait(duration: 0.25),
            .scale(to: 0.9, duration: 0.8),
            .scale(to: 1.0, duration: 2.0)
            ])
    }
    

    public let defaultButtonColor: UIColor = UIColor.init(red: 12/255, green: 89/255, blue: 179/255, alpha: 1)
    
    init() {
        templateShapesURL = docsBaseURL.appendingPathComponent("shapes.json")
    }
}
