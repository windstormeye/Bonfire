//
//  PJBottomCollectionView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/13.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJBottomCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    let identifierString = "PJBottomCollectionView"
    
    public var dataArray: Array<Any>?
    
    private var viewLayout: UICollectionViewFlowLayout?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewLayout = layout as? UICollectionViewFlowLayout
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        dataArray = []
        
        delegate = self
        dataSource = self
        backgroundColor = UIColor.clear
        
        register(PJBottomCollectionViewCell.self, forCellWithReuseIdentifier: identifierString)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if dataArray == nil {
            return 0
        } else {
            return (dataArray?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: identifierString,
                                                       for: indexPath) as! PJBottomCollectionViewCell
        cell.cellDataDict = dataArray?[indexPath.row] as! Dictionary
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    override func reloadData() {
        super.reloadData()
        // 居中
        let cellCount = self.numberOfItems(inSection: 0)
        let combinedItemWidth = (cellCount * Int((viewLayout?.itemSize.width)!)) + ((cellCount - 1) * Int((viewLayout?.minimumInteritemSpacing)!))
        var padding = (Int(self.width) - combinedItemWidth) / 2
        padding = padding > 0 ? padding :0 ;
        viewLayout?.sectionInset = UIEdgeInsets.init(top: 15, left: CGFloat(padding), bottom: 0, right: CGFloat(padding))
    }
    

}
