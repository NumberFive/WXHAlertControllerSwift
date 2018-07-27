//
//  WXHAlertProtocol.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/27.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit
protocol WXHAlertContainerProtocol {
    var appearAnimation: CAAnimation? { get }
    var disappearAnimation: CAAnimation? { get }
    
    func updateLayout()
    func setContentSize(_ size: CGSize)
    func setContentView(_ view: UIView)
}
