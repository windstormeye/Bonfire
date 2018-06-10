//
//  PJBlockPopView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/10.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

protocol PJBlockPopViewDelegate {
    func closeButtonClick(_ view: PJBlockPopView, closeButton: UIButton)
}

class PJBlockPopView: UIView {

    public var viewDelegate: PJBlockPopViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = .white
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: 0, height: 15))
        self.addSubview(titleLabel)
        titleLabel.text = "拖拽要添加的模块"
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.centerX = self.centerX
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        let closeButton = UIButton.init(frame: CGRect.init(x: 5, y: 0, width: 30, height: 30))
        self.addSubview(closeButton)
        closeButton.centerY = titleLabel.centerY
        closeButton.setImage(imageWithColor(UIImage.init(named: "Cancel")!, color: .black), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), for: .touchUpInside)
        
        // 顶左、右圆角
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight],
                                    cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    @objc private func closeButtonClick(_ button: UIButton) {
        viewDelegate?.closeButtonClick(self, closeButton: button)
    }
    
}
