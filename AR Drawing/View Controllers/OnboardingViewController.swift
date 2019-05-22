//
//  OnboardingViewController.swift
//  AR Drawing
//
//  Created by Shawn Ma on 5/21/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class OnboardingViewController: UIViewController {
    var enableCameraButton: UIButton!
    var largeText: UILabel!
    var smallText: UILabel!
    
    fileprivate func initSubViews() {
        largeText = UILabel()
        view.addSubview(largeText)
        largeText.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        largeText.textColor = .white
        largeText.textAlignment = .center
        largeText.numberOfLines = 0
        
        smallText = UILabel()
        view.addSubview(smallText)
        smallText.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        smallText.textColor = UIColor.init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        smallText.textAlignment = .center
        smallText.numberOfLines = 0
        
        enableCameraButton = UIButton()
        view.addSubview(enableCameraButton)
        enableCameraButton.layer.cornerRadius = 8.0
        enableCameraButton.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        enableCameraButton.setTitle("Enable Camera Access", for: .normal)
        enableCameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        enableCameraButton.setTitleColor(.black, for: .normal)
        enableCameraButton.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
    }
    
    fileprivate func setupLayouts() {
        largeText.text = "Make the World Your Canvas"
        largeText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.62)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(180)
        }
        
        smallText.text = "with the virtual lines you draw livened up to be colorful geometric shapes."
        smallText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.752)
            make.top.equalTo(largeText.snp.bottom).offset(28)
        }
        
        enableCameraButton.snp.makeConstraints { (make) in
            make.top.equalTo(smallText.snp.bottom).offset(87)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.539)
            make.height.equalTo(49)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        initSubViews()
        
        setupLayouts()
        
        enableCameraButton.addTarget(self, action: #selector(requestCamera), for: .touchUpInside)
    }

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] (granted) in
            guard granted == true else {return}
            self?.startAR()
        }
    }
    
    private func startAR() {
        DispatchQueue.main.async {
            let arVC = ARSceneViewController()
            self.present(arVC, animated: true) {
                UserDefaults.standard.set(true, forKey: Constants.shared.cameraAccess)
            }
        }
    }
    
    
    @objc
    func requestCamera() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined: requestCameraPermission()
        case .authorized: startAR()
        case .denied: showCameraSettings()
        case .restricted: break
        default:
            break
        }
    }
    
    private func showCameraSettings() {
        
        let alertController = UIAlertController (title: "This app requires\ncamera access", message: "In iPhone Settings, tap AR Masters and turn on camera", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    log.info("Settings opened: \(success)")
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Not now", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
