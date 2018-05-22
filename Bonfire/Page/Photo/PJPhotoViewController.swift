//
//  PJPhotoViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import Photos


class PJPhotoViewController: UIViewController {
    private var frontCameraView: PJPhotoCameraView?
    private var backCameraView: PJPhotoCameraView?
    private var coverButton: UIButton?
    private var coverView: UIView?
    
    private var isReversed: Bool?
    private var volume: Float?
    private var isAddVolume: Bool?
    private var touchVolumeBtnIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        // 检查授权
        if  isRightCamera() {
            backCameraView = PJPhotoCameraView.init(frame: CGRect.init(x: 0, y: 0,
                                                                       width: PJSCREEN_WIDTH,
                                                                       height: PJSCREEN_HEIGHT),
                                                    cameraType: .back)
            view.addSubview(backCameraView!)
        } else {
            PJShowSettingAlert(viewController: self, title: "未能打开相机", message: "点击前往”设置“打开授权")
        }
    }
    
    private func initView() {
        try! AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        PJHiddenSystemVolumnHUD()
        
        volume = AVAudioSession.sharedInstance().outputVolume + 0.001
        isReversed = true
        touchVolumeBtnIndex = 0
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Cancel"),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(cancelBarButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(editBarButtonClick))
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(volumeValueChange), name:  NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func editBarButtonClick() {
        
    }
    
    private func changeCameraView() {
        if isReversed == true {
            frontCameraView = PJPhotoCameraView.init(frame: CGRect.init(x: 0, y: 0,
                                                                        width: PJSCREEN_WIDTH,
                                                                        height: PJSCREEN_HEIGHT),
                                                     cameraType: .front)
            view.addSubview(frontCameraView!)
            UIView.transition(from: backCameraView!, to: frontCameraView!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft) { (animation) in
                if animation == true {
                    self.backCameraView?.removeFromSuperview()
                    self.isReversed = false
                    // 重新把coverButton拉取到最上层
                    self.view.bringSubview(toFront: self.coverView!)
                    self.view.bringSubview(toFront: self.coverButton!)
                    PJTapic.succee()
                }
            }
        } else {
            backCameraView = PJPhotoCameraView.init(frame: CGRect.init(x: 0, y: 0,
                                                                       width: PJSCREEN_WIDTH,
                                                                       height: PJSCREEN_HEIGHT),
                                                    cameraType: .back)
            view.addSubview(backCameraView!)
            UIView.transition(from: frontCameraView!, to: backCameraView!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight) { (animation) in
                if animation == true {
                    self.frontCameraView?.removeFromSuperview()
                    self.isReversed = true
                    // 重新把coverButton拉取到最上层
                    self.view.bringSubview(toFront: self.coverView!)
                    self.view.bringSubview(toFront: self.coverButton!)
                    PJTapic.succee()
                }
            }
        }
    }
    
    @objc private func coverBtnClick() {
        PJTapic.select()
    }
    
    @objc private func volumeValueChange() {
        var tempVolume = AVAudioSession.sharedInstance().outputVolume
        
        if  tempVolume != 0.0 && tempVolume != 1.0 {
            tempVolume -= 0.0625
        }
        print(volume!, tempVolume)
        if tempVolume == 1.0 {
            touchVolumeBtnIndex! += 1
            if touchVolumeBtnIndex! >= 2 {
                coverView?.isHidden = !(coverView?.isHidden)!
                touchVolumeBtnIndex = 0
            }
            return
        }
        if volume! > tempVolume {
            changeCameraView()
        } else {
            touchVolumeBtnIndex! += 1
            if touchVolumeBtnIndex! >= 2 {
                coverView?.isHidden = !(coverView?.isHidden)!
                touchVolumeBtnIndex = 0
            }
        }
        volume = tempVolume
        if volume == 0 {
            volume! += 0.001
        }
        
    }

    // 相机权限
    func isRightCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus != .restricted && authStatus != .denied
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
