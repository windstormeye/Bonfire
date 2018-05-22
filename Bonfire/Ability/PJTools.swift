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

func PJHiddenSystemVolumnHUD() {
    // 隐藏系统音量
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


func PJUILength(length: Int) -> CGFloat {
    return PJSCREEN_WIDTH * CGFloat(length) / 375
}

// 通知
let PJNotificationName_changeLanguage = "PJNotificationNameChangeLanguage"
