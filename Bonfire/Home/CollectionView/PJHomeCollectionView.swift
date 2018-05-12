//
//  PJHomeCollectionView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/12.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJHomeCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    let identifierString = "PJHomeCollectionView"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: identifierString,
                                                       for: indexPath) as! PJHomeCollectionViewCell
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
}
