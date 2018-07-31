//
//  ViewController.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/27.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var alert: WXHAlertController?
    var container: WXHAlertView?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonAction(_ sender: UIButton) {

        let view = UIView()
        view.backgroundColor = UIColor.brown

        let container = WXHAlertView()
        container.setContentSize(CGSize(width: 100, height: 50))
        container.setContentView(view)
        container.backgroundColor = UIColor.green

        let alert = WXHAlertController(container)
        alert.show(complete: nil)
    }
}


