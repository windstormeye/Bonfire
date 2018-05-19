//
//  PJPhotoViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJPhotoViewController: UIViewController {

    public var backScrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = UIColor.white
        title = "紧急拍照"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Cancel"),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(cancelBarButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(editBarButtonClick))
        
        backScrollView = {
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0,
                                                                  width: PJSCREEN_WIDTH,
                                                                  height: self.view.height))
            view.addSubview(scrollView)
            scrollView.backgroundColor = UIColor.clear
            scrollView.contentSize = CGSize.init(width: 0, height: PJSCREEN_HEIGHT + 1)
            return scrollView
        }()
        
        _ = { () -> UIButton in
            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0,
                                                          width: PJSCREEN_WIDTH,
                                                          height: (backScrollView?.height)! / 3))
            backScrollView?.addSubview(button)
            button.setTitle("前", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 58)
            button.addTarget(self, action: #selector(frontCameraBtnClick), for: .touchUpInside)

            return button
        }()
        
        _ = { () -> UIButton in
            let button = UIButton.init(frame: CGRect.init(x: 0, y: (backScrollView?.height)! / 3,
                                                          width: PJSCREEN_WIDTH,
                                                          height: (backScrollView?.height)! / 3))
            backScrollView?.addSubview(button)
            button.setTitle("后", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 58)
            button.addTarget(self, action: #selector(backCameraBtnClick), for: .touchUpInside)
            return button
        }()
        
        
    }
    
    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func editBarButtonClick() {
        
    }
    
    @objc private func frontCameraBtnClick() {
        let cameraView = PJPhotoCameraView.init(frame: view.frame, cameraType: .front)
        view.addSubview(cameraView)
    }
    
    @objc private func backCameraBtnClick() {
        let cameraView = PJPhotoCameraView.init(frame: view.frame, cameraType: .back)
        view.addSubview(cameraView)
    }

}
