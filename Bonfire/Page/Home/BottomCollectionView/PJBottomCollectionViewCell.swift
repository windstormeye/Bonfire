//
//  PJBottomCollectionViewCell.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/13.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJBottomCollectionViewCell: UICollectionViewCell {
    
    private var tempDataDict: Dictionary<String, String>?
    public var cellDataDict: Dictionary<String, String> {
        get {
            return self.tempDataDict!
        }
        set(dict) {
            self.tempDataDict = dict
            initView()
        }
    }
    
    private var imageView: UIImageView?
    
    private func initView() {
        imageView = {() -> UIImageView in
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: self.height))
            imageView.image = UIImage.init(named: cellDataDict["itemImageName"]!)
            self.addSubview(imageView)
            return imageView
        }()
    }
}
