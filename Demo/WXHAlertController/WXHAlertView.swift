//
//  WXHAlertView.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/30.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit
class WXHAlertView: UIView {
    var _contentSize: CGSize {
        didSet {
            self.updateLayout()
        }
    }
    var contentSize: CGSize {
        set {
            self.updateLayout()
        }
        get {
            return _contentSize
        }
    }

    init() {
        super.init()
        _contentSize = CGSize(width: 200, height: 150)
    }
}
extension WXHAlertView: WXHAlertContainerProtocol {
    var appearAnimation: CAAnimation? {
        get {
            return CAAnimation()
        }
    }
    
    var disappearAnimation: CAAnimation? {
        get {
            return CAAnimation()
        }
    }
    
    func updateLayout() {
        
    }
    
    func setContentSize(_ size: CGSize) {
        
    }
    
    func setContentView(_ view: UIView) {
        
    }
}
