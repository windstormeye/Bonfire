//
//  PJTools.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/12.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import AVFoundation
import Photos

// 屏幕宽高
let PJSCREEN_HEIGHT = UIScreen.main.bounds.height
let PJSCREEN_WIDTH = UIScreen.main.bounds.width

let PJTABBAR_HEIGHT = CGFloat(48)

// 位置相关
func x(object: UIView) -> CGFloat {
    return object.frame.origin.x
}
func y(object: UIView) -> CGFloat {
    return object.frame.origin.y
}
func w(object: UIView) -> CGFloat {
    return object.frame.size.width
}
func h(object: UIView) -> CGFloat {
    return object.frame.size.height
}


// 计算字符串长度
func getStringLength(string: String) -> CGFloat {
    let count = string.count;
    if inputLetterAndSpace(string) {
        return CGFloat(9 * count)
    }
    return CGFloat(16 * count)
}

func inputLetterAndSpace(_ string: String) -> Bool {
    let regex = "[ a-zA-Z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}


// 颜色相关
func PJRGB(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}


// 设备相关
func PJDeviceWithPortrait() -> Bool {
    return UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
}

// 隐藏系统音量
func PJHiddenSystemVolumnHUD() {
    UIApplication.shared.keyWindow?.insertSubview(MPVolumeView(frame: CGRect.init(x: -2000, y: -2000,
                                                                                  width: 1, height: 1)), at: 0)
}

func PJShowSettingAlert(viewController: UIViewController, title:String, message:String) {
    DispatchQueue.main.async(execute: { () -> Void in
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"去设置", style: .default, handler: { (action) -> Void in
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if let url = url, UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        viewController.present(alertController, animated: true, completion: nil)
    })
}

func PJDevice() -> String {
    let currentScreen = UIScreen.main.currentMode?.size
    if currentScreen == CGSize.init(width: 1125, height: 2436) {
        return "iPhoneX"
    } else {
        return "None"
    }
}

// 计算字符串长度
func PJUILength(length: Int) -> CGFloat {
    return PJSCREEN_WIDTH * CGFloat(length) / 375
}


func PJToolCaptureView(view: UIView) -> UIImage {
    UIGraphicsBeginImageContext(CGSize.init(width: view.frame.size.width, height: view.frame.size.height))
    view.drawHierarchy(in: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: false)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
}

func PJToolConvertViewToImage(view: UIView) -> UIImage {
    let viewSize: CGSize = view.bounds.size
    UIGraphicsBeginImageContextWithOptions(viewSize, true, UIScreen.main.scale)
    if let aContext = UIGraphicsGetCurrentContext() {
        view.layer.render(in: aContext)
    }
    let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

func PJToolGetCurrentViewToImage() -> UIImage {
    var imgSize = CGSize.zero
    imgSize = UIScreen.main.bounds.size
    UIGraphicsBeginImageContextWithOptions(imgSize, false, 0)
    let context = UIGraphicsGetCurrentContext()
    for window in UIApplication.shared.windows {
        context?.saveGState()
        context?.translateBy(x: window.center.x, y: window.center.y)
        context?.concatenate(window.transform)
        context?.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                             y: -window.bounds.size.height * window.layer.anchorPoint.y)
        
        if window.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        } else {
            window.layer.render(in: context!)
        }
        context?.restoreGState()
    }
    let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

// 权限
// 相机权限
func isRightCamera() -> Bool {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    return authStatus != .restricted && authStatus != .denied
}

//相册
func isRightAlbum() -> Bool{
      // iOS 9 及其以上系统运行
    let authStatus = PHPhotoLibrary.authorizationStatus()
    return authStatus != .restricted && authStatus != .denied
}

func isRightMicrophone() -> Bool{
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
    return authStatus != .restricted && authStatus != .denied
}

// 通知
let PJNotificationName_changeLanguage = "PJNotificationNameChangeLanguage"



// 动画相关

func PJBounceAnimationWithUp(y: CGFloat, button: UIButton, parentView: UIView) {
    UIView.transition(with: button, duration: 0.25, options: UIViewAnimationOptions.curveLinear, animations: {
        button.bottom = y - 10
    }, completion: {(animated) in
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                button.bottom += 13
            }, completion: { (animated) in
                if animated {
                    UIView.animate(withDuration: 0.25, animations: {
                        button.bottom -= 3
                    })
                }
            })
        }
    })
}
