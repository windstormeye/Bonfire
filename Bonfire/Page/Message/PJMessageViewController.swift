//
//  PJMessageViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/13.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJMessageViewController: UIViewController {

    public var backScrollView: UIScrollView?
    
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Cancel"),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(cancelBarButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(editBarButtonClick))
        
        backScrollView = {
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: PJSCREEN_WIDTH, height: self.view.height - (navigationController?.navigationBar.height)!))
            view.addSubview(scrollView)
            scrollView.backgroundColor = UIColor.clear
            scrollView.contentSize = CGSize.init(width: 0, height: PJSCREEN_HEIGHT + 100)
            return scrollView
        }()
    }
    
    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func editBarButtonClick() {
        
    }

}
