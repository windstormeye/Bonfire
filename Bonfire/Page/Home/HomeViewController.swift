//
//  ViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/12.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import CoreData
import Hero

class HomeViewController: UIViewController, PJHomeCollectionViewDelegate {

    private var colletionView: PJHomeCollectionView?
    private var bottomView: PJBottomCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        let isFirstLogin = UserDefaults.standard.bool(forKey: "isFirstLogin")
        if isFirstLogin == false {
            UserDefaults.standard.set(true, forKey: "isFirstLogin")
            PJHelper.initCollectionViewData()
            PJHelper.initBottomViewData()
        }
        
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

        let homeLayout = UICollectionViewFlowLayout()
        homeLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        homeLayout.itemSize = CGSize.init(width: 60, height: 80)
        homeLayout.minimumLineSpacing = 25
        homeLayout.minimumInteritemSpacing = 15
        homeLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 25, bottom: 0, right: 25)

        colletionView = PJHomeCollectionView.init(frame: view.frame, collectionViewLayout: homeLayout)
        colletionView?.viewDelegate = self
        view.addSubview(colletionView!)

        let bottomLayout = UICollectionViewFlowLayout()
        bottomLayout.itemSize = CGSize.init(width: 60, height: 60)
        bottomLayout.minimumLineSpacing = homeLayout.minimumLineSpacing
        bottomLayout.minimumInteritemSpacing = homeLayout.minimumInteritemSpacing
        bottomLayout.sectionInset = UIEdgeInsets.init(top: 15, left: 25, bottom: 0, right: 25)
        
        let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView.init(frame: CGRect.init(x: 0, y: view.height - 90,
                                                       width: PJSCREEN_WIDTH, height: 90))
        blurView.effect = blurEffect
        view.addSubview(blurView)
        bottomView = PJBottomCollectionView.init(frame: CGRect.init(x: 0, y: view.height - 90,
                                                                    width: PJSCREEN_WIDTH, height: 90), collectionViewLayout: bottomLayout)
        view.addSubview(bottomView!)
        
        
        colletionView?.dataArray = PJHelper.getCollectionViewData()
        colletionView?.reloadData()
        
        bottomView?.dataArray = PJHelper.getBottomViewData()
        bottomView?.reloadData()
    }

    func homeCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var vc: UIViewController? = nil
        
        switch indexPath.row {
        case 0:
            vc = PJPhotoViewController()
            break
        case 1:
            vc = PJMapViewController()
            break
        case 2:
            vc = PJSoundViewController()
            break;
        case 3:
            vc = PJProtectionViewController()
            break;
        case 4:
            vc = PJToolViewController()
            break;
        default:
            break
        }
        
        let nav = UINavigationController.init(rootViewController: vc!)
        nav.hero.isEnabled = true
        nav.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        PJTapic.tap()
        self.present(nav, animated: true, completion: nil)
    }
    
}

