//
//  WXHAlertController.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/27.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit

typealias WXHAlertHandler = () -> Void

let WXHAlertAppearAnimationDuration = 0.10
let WXHAlertDisappearAnimationDuration = 0.10

let WXHAlertAnimationKey = "WXHAlertAnimationKey"
let WXHAlertAppearAanimationKey = "WXHAlertAppearAanimationKey"
let WXHAlertDisappearAanimationKey = "WXHAlertDisappearAanimationKey"

let WXHAlertAppearAanimationValue = "WXHAlertAppearAanimationValue"
let WXHAlertDisappearAanimationValue = "WXHAlertDisappearAanimationValue"



class WXHAlertController: NSObject {
    var isShow = false
    var isAppearAnimationing = false
    var isDisappearAnimationing = false
    var dismissWhenMaskViewDidTap = true
    var maskViewDidTapHandler: WXHAlertHandler?
    var showCompleteHandler: WXHAlertHandler?
    var dismissCompleteHandler: WXHAlertHandler?
    
    var appearAnimation: CAAnimation {
        get {
            var animation: CAAnimation
            if self.container?.appearAnimation == nil {
                let animationOpacity = CABasicAnimation(keyPath: "opacity")
                animationOpacity.fromValue = 0
                animationOpacity.toValue = 1
                animationOpacity.duration = WXHAlertAppearAnimationDuration
                animationOpacity.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                animationOpacity.fillMode = kCAFillModeForwards
                animationOpacity.isRemovedOnCompletion = false
                animation = animationOpacity
            } else {
                animation = self.container!.appearAnimation!
            }
            animation.delegate = self
            animation.setValue(WXHAlertAppearAanimationValue, forKey: WXHAlertAnimationKey)
            return animation
        }
    }
    var disappearAnimation: CAAnimation {
        get {
            var animation: CAAnimation
            if self.container?.disappearAnimation == nil {
                let animationOpacity = CABasicAnimation(keyPath: "opacity")
                animationOpacity.toValue = 0
                animationOpacity.duration = WXHAlertAppearAnimationDuration
                animationOpacity.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animationOpacity.fillMode = kCAFillModeForwards
                animationOpacity.isRemovedOnCompletion = false
                animation = animationOpacity
            } else {
                animation = self.container!.disappearAnimation!
            }
            animation.delegate = self
            animation.setValue(WXHAlertDisappearAanimationValue, forKey: WXHAlertAnimationKey)
            return animation
        }
    }
    
    //MARK:- Mask
    var maskColor: UIColor {
        get {
            return self.maskView.backgroundColor!
        }
        set {
            self.maskView.backgroundColor = newValue
        }
    }
    var maskType : WXHAlertMaskViewType {
        get {
            return self.maskView.type
        }
        set {
            self.maskView.type = newValue
        }
    }
    private lazy var maskView: WXHAlertMaskView = {
        let view = WXHAlertMaskView()
        view.alertController = self
        view.delegate = self
        return view
    }()
    
    func maskViewDidTap(_ handler: @escaping WXHAlertHandler) {
        self.maskViewDidTapHandler = handler
    }
    
    var view: UIWindow {
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
    
    
    
    var container: WXHAlertContainerProtocol?
    
    override init() {
        super.init()
    }
    
    init(_ container: WXHAlertContainerProtocol) {
        self.container = container
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayout), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    @objc func updateLayout() {
        self.container?.updateLayout()
        self.maskView.frame = self.view.bounds
    }
    
    
    //MARK:- Show、Dismiss
    public func show(complete: WXHAlertHandler?) {
        self.showCompleteHandler = complete
        
        OperationQueue.main.addOperation {
            if !self.isShow {
                if let view = self.container as? UIView {
                    self.view.addSubview(view)
                    self.view.insertSubview(self.maskView, belowSubview: view)
                }
                self.updateLayout()
                
                self.appearWithAnimation()
                self.isShow = true
            }
        }
    }
    
    public func dismiss(complete: WXHAlertHandler?) {
        self.dismissCompleteHandler = complete
        OperationQueue.main.addOperation {
            self.disappearWithAnimation()
        }
    }
    
    func appearWithAnimation() {
        if !self.isShow && !self.isAppearAnimationing {
            self.isAppearAnimationing = true
            self.maskView.layer.add(self.maskView.appearAnimation, forKey: WXHAlertAppearAanimationKey)
            if let view = self.container as? UIView {
                view.layer.add(self.appearAnimation, forKey: WXHAlertAppearAanimationKey)
            }
        }
    }
    func disappearWithAnimation() {
        if self.isShow && !self.isDisappearAnimationing {
            self.isDisappearAnimationing = true
            self.maskView.layer.add(self.maskView.disappearAnimation, forKey: WXHAlertDisappearAanimationKey)
            if let view = self.container as? UIView {
                view.layer.add(self.disappearAnimation, forKey: WXHAlertDisappearAanimationKey)
            }
        }
    }
    
    
    func didAppear() {
        self.isAppearAnimationing = false
        
        if let view = self.container as? UIView {
            view.layer.removeAnimation(forKey: WXHAlertAppearAanimationKey)
        }
        self.maskView.layer.removeAnimation(forKey: WXHAlertAppearAanimationKey)
        self.showCompleteHandler?()
    }
    func didDisappear() {
        self.isShow = false
        self.isDisappearAnimationing = false
        
        if let view = self.container as? UIView {
            view.removeFromSuperview()
            view.layer.removeAnimation(forKey: WXHAlertDisappearAanimationKey)
        }
        self.maskView.removeFromSuperview()
        self.maskView.layer.removeAnimation(forKey: WXHAlertDisappearAanimationKey)
        self.dismissCompleteHandler?()
    }
}

extension WXHAlertController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let animationValue = anim.value(forKey: WXHAlertAnimationKey)
        if let value = animationValue as? String {
            if value == WXHAlertAppearAanimationValue {
                self.didAppear()
            } else if value == WXHAlertDisappearAanimationValue {
                self.didDisappear()
            }
        }
    }
}
extension WXHAlertController: WXHAlertMaskViewDelegate {
    func maskViewDidTap() {
        if self.dismissWhenMaskViewDidTap {
            self.dismiss(complete: nil)
        }
        self.maskViewDidTapHandler?()
    }
}
