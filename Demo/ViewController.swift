//
//  ViewController.swift
//  Demo
//
//  Created by 伍小华 on 2018/7/27.
//  Copyright © 2018年 伍小华. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let container = WXHAlertView()
        let alert = WXHAlertController(container)
        
        alert.container = container
        
    }




}
