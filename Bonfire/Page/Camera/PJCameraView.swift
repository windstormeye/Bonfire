//
//  PJCameraView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol PJCameraViewDelegate {
    func takePhotoImage(image: UIImage)
}

class PJCameraView: UIView, AVCapturePhotoCaptureDelegate {

    private var session: AVCaptureSession?
    private var videoInput: AVCaptureDeviceInput?
    private var imageOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    private(set) var isFrontCamera: Bool?
    
    public var delegate: PJCameraViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initAVCaptureSession()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = UIColor.black
        isFrontCamera = false
    }
    
    private func initAVCaptureSession() {
        session = AVCaptureSession.init()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        videoInput = try! AVCaptureDeviceInput.init(device: device!)
        
        imageOutput = AVCapturePhotoOutput.init()
        let setDic = [
            AVVideoCodecKey : AVVideoCodecType.jpeg
        ]
        let imageSetting = AVCapturePhotoSettings.init(format: setDic)
        imageOutput?.photoSettingsForSceneMonitoring = imageSetting
        
        if (session?.canAddInput(videoInput!))! {
            session?.addInput(videoInput!)
        }
        if (session?.canAddOutput(imageOutput!))! {
            session?.addOutput(imageOutput!)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer?.frame = self.frame
        self.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
    }
    
    /*
     *  转换前后相机
     */
    public func switchCameraControl() {
        let animation = CATransition()
        animation.duration = 0.35
        animation.timingFunction = CAMediaTimingFunction.easeInOut
        animation.type = "oglFlip"
        
        var position: AVCaptureDevice.Position?
        if isFrontCamera! {
            position = AVCaptureDevice.Position.back
            animation.subtype = kCATransitionFromRight
        } else {
            position = AVCaptureDevice.Position.front
            animation.subtype = kCATransitionFromLeft
        }
        
        for d: AVCaptureDevice in AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position!).devices {
            if d.position == position {
                
                previewLayer?.add(animation, forKey: nil)
                
                previewLayer?.session?.beginConfiguration()
                let input = try? AVCaptureDeviceInput(device: d)
                for oldInput in (previewLayer?.session?.inputs)! {
                    previewLayer?.session?.removeInput(oldInput)
                }
                previewLayer?.session?.addInput(input!)
                previewLayer?.session?.commitConfiguration()
                break
            }
        }
        
        isFrontCamera = !isFrontCamera!
    }
    
    /*
     *  拍照
     */
    public func takePhoto() {
        imageOutput?.capturePhoto(with: AVCapturePhotoSettings.init(format: [
            AVVideoCodecKey : AVVideoCodecType.jpeg
            ]), delegate: self)
    }
    
    /*
     *  在开始捕获时，播放相反音波声音
     */
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        var soundID: SystemSoundID = 0
        let path = Bundle.main.path(forResource: "photoShutter2", ofType: "caf")
        let flieurl = URL.init(fileURLWithPath: path!, isDirectory: false)
        AudioServicesCreateSystemSoundID(flieurl as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    /*
     *  保存图片
     */
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let data = photo.fileDataRepresentation()
        if data != nil {
            let image = UIImage.init(data: data!)
            delegate?.takePhotoImage(image: image!)
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: nil)
        }
    }
    
    

}
