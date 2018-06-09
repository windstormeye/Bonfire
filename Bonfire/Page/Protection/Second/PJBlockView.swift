//
//  PJBlockView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/9.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJBlockView: UIView {

    public var dataSourceArray: Array<String>? {
        didSet {
            updateBlockView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = .clear
        
        updateBlockView()
    }
    
    private func updateBlockView() {
        let addButton = UIButton.init(frame: CGRect.init(x: 0, y: 10, width: self.width, height: 70))
        addButton.setTitle("＋", for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        addButton.setTitleColor(.white, for: .normal)
        self.addSubview(addButton)
        
        let boder = CAShapeLayer.init()
        boder.strokeColor = UIColor.lightGray.cgColor
        boder.path = UIBezierPath.init(roundedRect: addButton.bounds, cornerRadius: 8.0).cgPath
        boder.frame = addButton.bounds
        boder.lineWidth = 1.0
        boder.fillColor = UIColor.clear.cgColor
        boder.lineCap = "round"
        boder.lineDashPattern = [4, 2]
        addButton.layer .addSublayer(boder)
    }
    
    
    
}
