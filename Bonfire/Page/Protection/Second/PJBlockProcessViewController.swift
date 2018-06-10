//
//  PJBlockProcessViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/9.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJBlockProcessViewController: PJBaseViewController, PJBlockViewDelegate, PJBlockPopViewDelegate {

    private var blockView: PJBlockView?
    
    lazy var popView: PJBlockPopView = {
        let popView = PJBlockPopView.init(frame: CGRect.init(x: 0, y: view.height, width: view.width, height: view.height * 0.4))
        popView.viewDelegate = self
        view.addSubview(popView)
        
        return popView
    }()
    
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
            blockview.viewDelegate = self
            view.addSubview(blockview)
            
            return blockview
        }()
    }
    
    private func nextVC() {
        
    }
    
    @objc private func cancelBarButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
    func addButtonClick() {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.popView.top = self.view.height * 0.6
        }, completion: { (animated) in
            if animated {
                PJTapic.tap()
            }
        })
    }

    func closeButtonClick(_ view: PJBlockPopView, closeButton: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.popView.top = self.view.height
        })
    }
    
}
