//
//  PJBlockProcessViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/9.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJBlockProcessViewController: PJBaseViewController {

    private var blockView: PJBlockView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        title = "模块流程"
        view.backgroundColor = .black
        navigationController?.navigationBar.shadowImage = UIImage.init()

        leftBarButtonItemAction(action: #selector(cancelBarButtonClick), iconName: "back")
        rightBatButtonItemAction(action: Selector.init(("nextVC")), title: "下一步")
        
        blockView = {
            let blockview = PJBlockView.init(frame: CGRect.init(x: 0, y: 0, width: PJSCREEN_WIDTH * 0.8, height: view.height))
            blockview.centerX = view.centerX
            view.addSubview(blockview)
            
            return blockview
        }()
    }
    
    private func nextVC() {
        
    }
    
    @objc private func cancelBarButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
}
