//
//  PJPhotoViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import MediaPlayer
import Photos


class PJPhotoViewController: UIViewController, PJCameraViewDelegate {
    private var frontCameraView: PJPhotoCameraView?
    private var backCameraView: PJCameraView?
    private var coverButton: UIButton?
    private var cameraTagButton: UIButton?
    private var coverView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 检查授权
        if  isRightCamera() {
            backCameraView = PJCameraView.init(frame: view.frame)
            backCameraView?.delegate = self
            view.addSubview(backCameraView!)
        } else {
            PJShowSettingAlert(viewController: self, title: "未能打开相机", message: "点击前往”设置“打开授权")
        }
        
        initView()
    }
    
    private func initView() {
        try! AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        PJHiddenSystemVolumnHUD()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage.init()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Cancel"),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(cancelBarButtonClick))
        
        let tView = UIView.init(frame: CGRect.init(x: (PJSCREEN_WIDTH - (navigationController?.navigationBar.width)! * 0.7) / 2, y: 0, width: (navigationController?.navigationBar.width)! * 0.7, height: (navigationController?.navigationBar.height)!))
        tView.backgroundColor = UIColor.clear
        navigationItem.titleView = tView
        let tViewTap = UITapGestureRecognizer.init(target: self, action: #selector(navigationBarTap))
        tViewTap.numberOfTapsRequired = 1
        tView.addGestureRecognizer(tViewTap)
        
        
        coverButton = {
            let button = UIButton.init(frame: view.frame)
            view.addSubview(button)
            view.bringSubview(toFront: button)
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(coverBtnClick), for: .touchUpInside)
            return button
        }()
        
        coverView = {
            let tempview = UIView.init(frame: CGRect.init(x: 0,
                                                          y: -((navigationController?.navigationBar.height)!) - 20,
                                                          width: PJSCREEN_WIDTH, height: PJSCREEN_HEIGHT + 20))
            tempview.backgroundColor = UIColor.black
            tempview.isHidden = true
            view.addSubview(tempview)
            let onePan = UITapGestureRecognizer.init(target: self, action: #selector(coverBtnClick))
            onePan.numberOfTapsRequired = 1
            tempview.addGestureRecognizer(onePan)
            return tempview
        }()
        
        cameraTagButton = {
            let button = UIButton.init(frame: CGRect.init(x: PJSCREEN_WIDTH - 40, y: (navigationController?.navigationBar.height)! - 40, width: 30, height: 30))
            navigationController?.navigationBar.addSubview(button)
            button.setImage(UIImage.init(named: "backCamera"), for: .normal)
            
            return button
        }()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeCameraView), name:  NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    @objc private func cancelBarButtonClick() {
        let img = UIImageView.init(frame: view.frame)
        img.image = PJToolCaptureView(view: backCameraView!)
        view.addSubview(img)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func editBarButtonClick() {
        
    }
    
    @objc private func changeCameraView() {
        backCameraView?.switchCameraControl()
        if (backCameraView?.isFrontCamera)! {
            cameraTagButton?.setImage(UIImage.init(named: "frontCamera"), for: .normal)
        } else {
            cameraTagButton?.setImage(UIImage.init(named: "backCamera"), for: .normal)
        }
    }
    
    @objc private func coverBtnClick() {
    
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.backCameraView?.takePhoto()
            } else {
                PJShowSettingAlert(viewController: self,
                                   title: "Bonfire需要您的相册权限",
                                   message: "前往”设置“授权")
            }
        }
        
    }
    
    func takePhotoImage(image: UIImage) {
        PJTapic.select()
    }
    
    @objc func navigationBarTap() {
        PJTapic.succee()
        if (coverView?.isHidden)! {
            coverView?.isHidden = false
        } else {
            coverView?.isHidden = true
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
