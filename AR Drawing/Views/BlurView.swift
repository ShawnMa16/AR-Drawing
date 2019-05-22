//
//  BlurryView.swift
//  Sex_project_ED
//
//  Created by Shawn Ma on 2/11/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import UIKit

class BlurView: UIView {
    
    var isActive: Bool = false {
        didSet {
            if isActive {
                self.visualEffectView.effect = UIBlurEffect(style: .dark)
            } else {
                self.visualEffectView.effect = nil
            }
        }
    }

    var visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
