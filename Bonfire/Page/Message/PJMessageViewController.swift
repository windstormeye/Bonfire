//
//  PJMessageViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/13.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initView() {
        view.backgroundColor = UIColor.white
        title = "紧急短信"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
