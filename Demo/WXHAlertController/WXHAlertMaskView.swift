//
//  WXHAlertMaskView.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/27.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit

enum WXHAlertMaskViewType: Int {
    case color = 0
    case none
    case blur
}

protocol WXHAlertMaskViewTypeDelegate: class {
    func maskViewDidTap()
}
class WXHAlertMaskView: UIView {
    
    weak var delegate: WXHAlertMaskViewTypeDelegate?
    var type : WXHAlertMaskViewType = .color
    var clickedIndex = 0
    var _visualEffectView: UIVisualEffectView?
    var visualEffectView: UIVisualEffectView {
        get {
            if _visualEffectView == nil {
                let blurEffect = UIBlurEffect(style: .light)
                _visualEffectView = UIVisualEffectView(effect: blurEffect)
                _visualEffectView!.alpha = 0.8
            }
            return _visualEffectView!
        }
    }
    
    lazy var appearAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = WXHAlertAppearAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    lazy var disappearAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.toValue = 0
        animation.duration = WXHAlertDisappearAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    var alertController: WXHAlertContainer?
    
    convenience init() {
        self.init()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.type != .blur {
            if _visualEffectView != nil {
                _visualEffectView?.removeFromSuperview()
                _visualEffectView = nil
            }
        } else {
            visualEffectView.frame = self.bounds
            if visualEffectView.superview == nil {
                self.addSubview(visualEffectView)
            }
        }
        if self.type != .color {
            self.backgroundColor = UIColor.clear
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.type == .none {
            if clickedIndex % 2 == 0 {
                self.tapGestureAction()
            }
            clickedIndex += 1
            return false
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
    @objc public func tapGestureAction() {
        self.delegate?.maskViewDidTap()
    }
    
}
