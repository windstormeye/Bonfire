//
//  PJSoundViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/3.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import AVFoundation

class PJSoundViewController: PJBaseViewController, AVAudioRecorderDelegate {
    // 录音器
    var recorder:AVAudioRecorder?
    // 播放器
    var player:AVAudioPlayer?
    // 录音器设置参数数组
    var recorderSeetingsDic:[String : Any]?
    // 录音存储路径
    var aacPath:String?
    /// 声音数据数组
    private var soundMeters: [Float]!
    /// 声音数据数组容量
    private let soundMeterCount = 10
    
    private var isShowPlayerButton: Bool = false
    
    private let recorderSetting = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//声音质量
    
    private var recoderButton: UIButton?
    private var playerButton: UIButton?
    
    var lineView: PJSoundLineView?
    var timer: Timer?
    
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
        
        lineView = {
            let tempView = PJSoundLineView.init(frame: CGRect.init(x: 0, y: 0, width: view.width, height: view.height - (recoderButton?.height)! * 2 - 50))
            view.addSubview(tempView)
            
            return lineView
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
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
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
            recorder!.delegate = self
            recorder!.isMeteringEnabled = true
            recorder!.record()
        }
        soundMeters = [Float]()
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self,
                                     selector: #selector(updateMeters), userInfo: nil, repeats: true)
    }
    
    @objc private func updateMeters() {
        recorder?.updateMeters()
        addSoundMeter(item: (recorder?.averagePower(forChannel: 0))!)
    }
    
    private func addSoundMeter(item: Float) {
        if soundMeters.count < soundMeterCount {
            soundMeters.append(item)
        } else {
            for (index, _) in soundMeters.enumerated() {
                if index < soundMeterCount - 1 {
                    soundMeters[index] = soundMeters[index + 1]
                }
            }
            // 插入新数据
            soundMeters[soundMeterCount - 1] = item
            NotificationCenter.default.post(name: NSNotification.Name.init("updateMeters"), object: soundMeters)
        }
    }
    
    @objc private func audioStopRecoder() {
        recorder?.stop()
        recorder = nil
        timer?.invalidate()
        soundMeters.removeAll()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.playerButton?.isHidden = false
            self.recoderButton?.left = self.view.centerX + (self.recoderButton?.width)! / 3
        }) { (animated) in
            if animated && self.isShowPlayerButton == false {
                self.isShowPlayerButton = true
                PJBounceAnimationWithUp(y: (self.recoderButton?.bottom)!,
                                        button: self.playerButton!,
                                        parentView: self.view)
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
