//
//  WXHAlertController.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/27.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit

typealias WXHAlertHandler = () -> Void

let WXHAlertAppearAnimationDuration = 0.15
let WXHAlertDisappearAnimationDuration = 0.15

class WXHAlertController: NSObject {
    var isShow = false
    var isAppearAnimationing = false
    var isDisappearAnimationing = false
    var dismissWhenMaskViewDidTap = true
    
    //MARK:- Mask
    var maskColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    var maskType : WXHAlertMaskViewType {
        get {
            return self.maskView.type
        }
        set {
            self.maskView.type = maskType
        }
    }
    
    var superView: UIWindow {
        get {
            let window = UIApplication.shared.keyWindow
            if window?.windowLevel != UIWindowLevelNormal{
                let windows = UIApplication.shared.windows
                for tempWindow in windows {
                    if tempWindow.windowLevel == UIWindowLevelNormal {
                        return tempWindow
                    }
                }
            }
            return window!
        }
    }
    
    lazy var maskView: WXHAlertMaskView = {
        let view = WXHAlertMaskView()
        return view
    }()
    
    var container: WXHAlertContainer?
    
    override init() {
        super.init()
    }
    
    init(container: WXHAlertContainer) {
        self.container = container
        super.init()
    }
    
    public func show(complete: @escaping WXHAlertHandler) {
        assert(self.container == nil, "container didn't set")
        
    }
    
    public func dismiss(complete: @escaping WXHAlertHandler) {
        
    }
}

extension WXHAlertController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}
