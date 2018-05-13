//
//  PJHomeCollectionViewCell.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/12.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJHomeCollectionViewCell: UICollectionViewCell {
    
    private var tempCellDataDict: Dictionary<String, String>?
    public var cellDataDict: Dictionary<String, String> {
        get {
            return self.tempCellDataDict!
        } set (dict) {
            self.tempCellDataDict = dict
            initView()
        }
    }
    
    private var cellImageView: UIImageView?
    private var cellTitleLabel: UILabel?

    private func initView() {
        cellImageView = {() -> UIImageView in
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0,
                                                                width: self.width, height: self.width))
            imageView.image = UIImage.init(named: cellDataDict["itemImageName"]!)
            self.addSubview(imageView)
            return imageView
        }()
        
        cellTitleLabel = {() -> UILabel in
            let label = UILabel.init(frame: CGRect.init(x: 0, y: (cellImageView?.bottom)!,
                                                        width: self.width, height: self.height - self.width + 10))
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = cellDataDict["itemName"]
            self.addSubview(label)
            return label
        }()
        
    }
}
