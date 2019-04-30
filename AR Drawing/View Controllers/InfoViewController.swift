//
//  InfoViewController.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/28/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit

class InforViewController: UIViewController {
    fileprivate let blurView = BlurView()
    
    fileprivate let dismissButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    fileprivate func setupViews() {
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(50)
        }
        dismissButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        dismissButton.setImage(UIImage(named: "dismiss"), for: .normal)
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.contentHorizontalAlignment = .fill
        dismissButton.imageEdgeInsets = Constants.shared.buttonInsets
        
        
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overFullScreen
        view.addSubview(blurView)
        blurView.isActive = true
        blurView.frame = view.bounds
        view.backgroundColor = .clear
        
        setupViews()
    }
    
    @objc
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
