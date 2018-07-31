//
//  WXHAlertView.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/30.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit
class WXHAlertView: UIView {
    var contentSize: CGSize
    var contentView: UIView?

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override init(frame: CGRect) {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 150)
        contentSize = CGSize(width: rect.size.width, height: rect.size.height)
        super.init(frame: rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView?.frame = self.bounds
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01 {
            return nil
        }
        if !self.point(inside: point, with: event) {
            return nil
        }
        
        for i in (0 ..< self.subviews.count).reversed() {
            let subView = self.subviews[i]
            let subPoint = self.convert(point, to: subView)
            if let fitView = subView.hitTest(subPoint, with: event) {
                return fitView
            }
        }
        return nil
    }

}
extension WXHAlertView: WXHAlertContainerProtocol {
    var appearAnimation: CAAnimation? {
        get {
            let animatGroup = CAAnimationGroup()
            
            let animatScale = CAKeyframeAnimation(keyPath: "transform.scale")
            animatScale.values = [0.0,0.5,1.0,1.2,1.1,1.0]
            
            let animatOpacity = CABasicAnimation(keyPath: "opacity")
            animatOpacity.fromValue = 0
            animatOpacity.toValue = 1.0
            
            animatGroup.animations = [animatScale, animatOpacity]
            animatGroup.duration = WXHAlertAppearAnimationDuration
            animatGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animatGroup.fillMode = kCAFillModeForwards
            animatGroup.isRemovedOnCompletion = false
            return animatGroup
        }
    }
    
    var disappearAnimation: CAAnimation? {
        get {
            let animatGroup = CAAnimationGroup()
            let animatScale = CABasicAnimation(keyPath: "transform.scale")
            animatScale.toValue = 0.1
            
            let animatOpacity = CABasicAnimation(keyPath: "opacity")
            animatOpacity.toValue = 0
            
            animatGroup.animations = [animatScale,animatOpacity]
            animatGroup.duration = WXHAlertDisappearAnimationDuration
            animatGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animatGroup.fillMode = kCAFillModeForwards
            animatGroup.isRemovedOnCompletion = false
            return animatGroup
        }
    }
    
    func updateLayout() {
        var width: CGFloat = self.superview?.frame.size.width ?? 0
        var height: CGFloat = self.superview?.frame.size.height ?? 0

        width = (width - self.contentSize.width)/2
        height = (height - self.contentSize.height)/2

        self.frame = CGRect(x: width,
                            y: height,
                            width: self.contentSize.width,
                            height: self.contentSize.height)
    }
    
    func setContentSize(_ size: CGSize) {
        self.contentSize = size
        self.updateLayout()
    }
    
    func setContentView(_ view: UIView) {
        if self.contentView != view {
            self.contentView?.removeFromSuperview()
            self.contentView = view
            self.addSubview(self.contentView!)
        }
    }
}
