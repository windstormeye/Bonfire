//
//  ViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/12.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initView() {
//        let isFirstLogin = UserDefaults.standard.bool(forKey: "isFirstLogin")
//        if isFirstLogin == true {
//            UserDefaults.standard.set(false, forKey: "isFirstLogin")
//        } else {
//            UserDefaults.standard.set(true, forKey: "isFirstLogin")
//        }
//
        view.backgroundColor = UIColor.white
        let backgroundView = {() -> UIImageView in
            let imageView = UIImageView.init(frame: UIScreen.main.bounds)
            imageView.image = UIImage.init(named: "default")
            let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
            let blurView = UIVisualEffectView.init(effect: blurEffect)
            blurView.frame = UIScreen.main.bounds
            imageView.addSubview(blurView)
            return imageView
        }()
        view.addSubview(backgroundView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.itemSize = CGSize.init(width: 60, height: 80)
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 25, bottom: 0, right: 25)
        let colletionView = PJHomeCollectionView.init(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(colletionView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}

