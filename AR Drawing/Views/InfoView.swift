//
//  InfoView.swift
//  AR Drawing
//
//  Created by Shawn Ma on 5/21/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import Foundation
import UIKit

class InfoView: UIView {
    private var titleLabel: UILabel!
    private var bodyTextView: UITextView!
    private var privacyButton: UIButton!
    private var closeButton: UIButton!
    
    var closeViewHandler: () -> Void = {}
    weak var textViewDelegate: UITextViewDelegate? {
        didSet {
            bodyTextView.delegate = textViewDelegate
        }
    }
    
    fileprivate func initSubViews() {
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.text = "About"
        
        bodyTextView = UITextView()
        bodyTextView.textColor = .black
        bodyTextView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        bodyTextView.text = Constants.shared.appInfo
        
        privacyButton = UIButton()
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        privacyButton.setTitleColor(Constants.shared.defaultButtonColor, for: .normal)
        privacyButton.setTitleColor(Constants.shared.defaultButtonColor.withAlphaComponent(0.3), for: .highlighted)
        
        closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        closeButton.setTitleColor(Constants.shared.defaultButtonColor, for: .normal)
        closeButton.setTitleColor(Constants.shared.defaultButtonColor.withAlphaComponent(0.3), for: .highlighted)

    }
    
    fileprivate func setupSubViews() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
        self.addSubview(bodyTextView)
        bodyTextView.isEditable = false
        bodyTextView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalToSuperview().offset(-86)
        }
        
        self.addSubview(privacyButton)
        privacyButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(49)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(49)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.cornerRadius = 12.0
        
        initSubViews()
        
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func closeView() {
        closeViewHandler()
    }
}
