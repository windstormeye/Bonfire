//
//  PJPhotoCameraView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import AVFoundation


class PJPhotoCameraView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    private lazy var  session : AVCaptureSession = AVCaptureSession()
    //输入设备 (摄像头)
    private var deviceInput : AVCaptureInput?
    //输入对象
    private lazy var deviceOutPut : AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    private lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer.init(session: self.session) // 闭包要访问外界数据  要self
        layer.frame = UIScreen.main.bounds
        return layer
    }()
    
    
    // MARK: - Init Methods
    
    init(frame: CGRect, cameraType: AVCaptureDevice.Position) {
        super.init(frame: frame)
        deviceInput = {
            let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                 for: AVMediaType.video, position: cameraType)
            do {
                let input = try AVCaptureDeviceInput.init(device: device!)
                return input
            }catch{
                print(error)
                return nil
            }
        }()
        
        startScan()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startScan(){
        //1.判断能否将输入添加到会话中
        if !session.canAddInput(deviceInput!) {
            return
        }
        //2.判断能否将输出添加到会话中
        if !session.canAddOutput(deviceOutPut) {
            return
        }
        //3.添加到会话中
        session.addInput(deviceInput!)
        session.addOutput(deviceOutPut)
        //4.设置输出能够解析的数据类型 (一定要在输出对象添加到会话之后才能设置,否则Bug)
        deviceOutPut.metadataObjectTypes = deviceOutPut.availableMetadataObjectTypes  //设置系统所有的数据类型都能解析
        //5.设置输出对象的代理 (只要解析成功就会通知代理)
        deviceOutPut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //添加预览图层到底层
        self.layer.insertSublayer(previewLayer, at: 0)
        //6.告诉session会话,开始扫描
        session.startRunning()
    }
    
    public func takePhoto() {
        let connection = deviceOutPut
    }
    
}
