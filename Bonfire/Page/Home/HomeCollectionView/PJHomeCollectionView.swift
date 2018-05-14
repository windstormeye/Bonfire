//
//  PJHomeCollectionView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/12.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

protocol PJHomeCollectionViewDelegate {
    func homeCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class PJHomeCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    let identifierString = "PJHomeCollectionView"
    
    public var dataArray: Array<Any>?
    public var viewDelegate: PJHomeCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
        register(PJHomeCollectionViewCell.self,
                                 forCellWithReuseIdentifier: identifierString)
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
                                                       for: indexPath) as! PJHomeCollectionViewCell
        cell.cellDataDict = dataArray?[indexPath.row] as! Dictionary
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.homeCollectionView(self, didSelectItemAt: indexPath)
    }
    
}
