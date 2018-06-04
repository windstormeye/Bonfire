//
//  PJSoundLineView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/4.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJSoundLineView: UIView {


    //MARK: Private Properties
    /// 声音表数组
    private var soundMeters: [Float]!
    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentMode = .redraw   //内容模式为重绘，因为需要多次重复绘制音量表
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notice:)), name: NSNotification.Name.init("updateMeters"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if soundMeters != nil && soundMeters.count > 0 {
            let context = UIGraphicsGetCurrentContext()
            context?.setLineCap(.round)
            context?.setLineJoin(.round)
            context?.setStrokeColor(UIColor.white.cgColor)
            
            let noVoice = -46.0     // 该值代表低于-46.0的声音都认为无声音
            let maxVolume = 55.0    // 该值代表最高声音为55.0
            context?.setLineWidth(2)
            for (index, item) in soundMeters.enumerated() {
                //计算对应线段高度，并放大五倍
                let position = maxVolume - (Double(item * 5) - noVoice)
                context?.addLine(to: CGPoint(x: Double(index * 41),
                                             y: position + Double(self.height / 2)))
                context?.move(to: CGPoint(x: Double(index * 41),
                                          y: position + Double(self.height / 2)))
            }
            context?.strokePath()
        }
    }
    
    @objc private func updateView(notice: Notification) {
        soundMeters = notice.object as! [Float]
        setNeedsDisplay()
    }

}
