//
//  PJCameraView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import AVFoundation

class PJCameraView: UIView, AVCapturePhotoCaptureDelegate {

    private var session: AVCaptureSession?
    private var videoInput: AVCaptureDeviceInput?
    private var stillImageOutput: AVCaptureStillImageOutput?
    private var imageOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    private var isFrontCamera: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initAVCaptureSession()
        isFrontCamera = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initAVCaptureSession() {
        session = AVCaptureSession.init()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        videoInput = try! AVCaptureDeviceInput.init(device: device!)
        
        // 非iOS 10
        stillImageOutput = AVCaptureStillImageOutput.init()
        let outputSettings = [
            AVVideoCodecKey : AVVideoCodecType.jpeg
        ]
        stillImageOutput?.outputSettings = outputSettings
        

        
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
    
    public func switchCameraControl() {
        var position: AVCaptureDevice.Position?
        if isFrontCamera! {
            position = AVCaptureDevice.Position.front
        } else {
            position = AVCaptureDevice.Position.back
        }

        if #available(iOS 10.0, *) {
            for d: AVCaptureDevice in AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position!).devices {
                if d.position == position {
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
        } else {
            for d: AVCaptureDevice in AVCaptureDevice.devices(for: .video) {
                if d.position == position {
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
        }
        
        
        isFrontCamera = !isFrontCamera!
    }
    
    public func takePhoto() {
        if #available(iOS 10, *) {
            imageOutput?.capturePhoto(with: AVCapturePhotoSettings.init(format: [
                AVVideoCodecKey : AVVideoCodecType.jpeg
                ]), delegate: self)
        } else {
            let stillImageConnection: AVCaptureConnection? = stillImageOutput?.connection(with: .video)
            stillImageOutput?.captureStillImageAsynchronously(from: stillImageConnection!, completionHandler: {(_ imageDataSampleBuffer: CMSampleBuffer?, _ error: Error?) -> Void in
                let jpegData: Data? = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                let imgView = UIImageView.init(frame: self.frame)
                imgView.image = UIImage.init(data: jpegData!)
                self.addSubview(imgView)
            })
        }
        
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let data = photo.fileDataRepresentation()
        let imgView = UIImageView.init(frame: self.frame)
        imgView.image = UIImage.init(data: data!)
        self.addSubview(imgView)
//        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    

}
