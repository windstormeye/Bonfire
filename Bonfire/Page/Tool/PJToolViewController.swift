//
//  PJToolViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/8.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJToolViewController: PJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
       self.isTitleLarge = true
        self.title = "工具箱"
    }


}
