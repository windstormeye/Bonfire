//
//  PJSoundViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/3.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import AVFoundation

class PJSoundViewController: PJBaseViewController, AVAudioSessionDelegate {
    // 录音器
    var recorder:AVAudioRecorder?
    // 播放器
    var player:AVAudioPlayer?
    // 录音器设置参数数组
    var recorderSeetingsDic:[String : Any]?
    // 录音存储路径
    var aacPath:String?
    
    private var recoderButton: UIButton?
    private var playerButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        self.leftBarButtonItemAction(action: #selector(cancelBarButtonClick))
        
        view.backgroundColor = .black
        navigationController?.navigationBar.shadowImage = UIImage.init()
        
        initAudio()

        
        if !isRightMicrophone() {
            PJShowSettingAlert(viewController: self, title: "需要您的麦克风权限", message: "协助录制您的环境音")
        }
        
        recoderButton = {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0,
                                                          width: PJSCREEN_WIDTH * 0.2, height: PJSCREEN_WIDTH * 0.2))
            view.addSubview(button)
            button.centerX = view.centerX
            button.bottom = view.height - button.height
            button.setImage(UIImage.init(named: "mic"), for: .normal)
            button.addTarget(self, action: #selector(audioRecoder), for: .touchDown)
            button.addTarget(self, action: #selector(audioStopRecoder), for: .touchUpOutside)
            button.addTarget(self, action: #selector(audioStopRecoder), for: .touchUpInside)
            
            return button
        }()
        
        playerButton = {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: view.height, width: (recoderButton?.width)!, height: (recoderButton?.width)!))
            button.setImage(UIImage.init(named: "play"), for: .normal)
            view.addSubview(button)
            button.right = view.centerX - button.width / 3
            button.isHidden = true
            button.addTarget(self, action: #selector(audioPlayer), for: .touchUpInside)
            
            return button
        }()
        
    }
    
    func initAudio() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // 录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        // 支持后台
        try! session.setActive(true)
        //获取Document目录
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask, true)[0]
        aacPath = docDir + "/play.aac"
        //初始化字典并添加设置参数
        recorderSeetingsDic = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            //录音的声道数，立体声为双声道
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            // 录音器每秒采集的录音样本数
            AVSampleRateKey : 44100.0
        ]
    }

    @objc private func audioRecoder() {
        //初始化录音器
        recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!,
                                        settings: recorderSeetingsDic!)
        if recorder != nil {
            recorder!.prepareToRecord()
            recorder!.record()
        }
    }
    
    @objc private func audioStopRecoder() {
        recorder?.stop()
        recorder = nil
        
        UIView.animate(withDuration: 0.2, animations: {
            self.playerButton?.isHidden = false
            self.recoderButton?.left = self.view.centerX + (self.recoderButton?.width)! / 3
        }) { (animated) in
            if animated {
                PJTapic.select()
                UIView.animate(withDuration: 0.25, animations: {
                    self.playerButton?.bottom = (self.recoderButton?.bottom)!
                }, completion: { (animated) in
                    if animated {
                        PJTapic.select()
                    }
                })
            }
        }
        
    }
    
    
    
    @objc private func audioPlayer() {
        PJTapic.select()
        player = try? AVAudioPlayer(contentsOf: URL(string: aacPath!)!)
        if player == nil {
            print("播放失败")
        }else{
            try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            player?.play()
        }
    }
    
    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
