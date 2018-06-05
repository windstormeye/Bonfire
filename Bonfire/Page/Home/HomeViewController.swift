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
            initCollectionViewData()
            initBottomViewData()
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
        
        getCollectionViewData()
        getBottomViewData()

    }

    func homeCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var vc: UIViewController? = nil
        
        switch indexPath.row {
        case 0:
            vc = PJMessageViewController.init()
            break
        case 1:
            vc = PJPhotoViewController.init()
            break
        case 4:
            vc = PJMapViewController.init()
        case 6:
            vc = PJSoundViewController.init()
        default:
            break
        }
        
        let nav = UINavigationController.init(rootViewController: vc!)
        nav.hero.isEnabled = true
        nav.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        PJTapic.tap()
        self.present(nav, animated: true, completion: nil)
    }
    
    private func initCollectionViewData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let itemImgArray = ["home_message", "home_photo", "home_setting", "home_clock",
                            "home_map", "home_card", "home_sound", "home_warning"]
        let itemName = ["紧急信息", "紧急相机", "设置", "定时保护", "实时共享", "救助卡", "实时录音", "一键报警"]
        
        for index in 0..<itemName.count {
            let homeData = NSEntityDescription.insertNewObject(forEntityName: "HomeCollectionView",
                                                               into: context) as! HomeCollectionView
            homeData.itemImageName = itemImgArray[index]
            homeData.itemName = itemName[index]
            
            do {
                try context.save()
                print("保存成功！")
            } catch {
                fatalError("不能保存：\(error)")
            }
        }
    }
    
    private func getCollectionViewData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HomeCollectionView>(entityName:"HomeCollectionView")
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            var tempDataArray: Array<Dictionary<String, String>> = []
            for info in fetchedObjects{
                let dict = [
                    "itemName" : info.itemName!,
                    "itemImageName" : info.itemImageName!
                ]
                tempDataArray.append(dict)
            }
            colletionView?.dataArray = tempDataArray
            colletionView?.reloadData()
        }
        catch {
            fatalError("查询失败：\(error)")
        }
    }
    
    private func initBottomViewData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let itemImgArray = ["phone"]
        let itemName = ["紧急电话"]
        
        for index in 0..<itemName.count {
            let homeData = NSEntityDescription.insertNewObject(forEntityName: "HomeBottomView",
                                                               into: context) as! HomeBottomView
            homeData.itemImageName = itemImgArray[index]
            homeData.itemName = itemName[index]
            
            do {
                try context.save()
                print("保存成功！")
            } catch {
                fatalError("不能保存：\(error)")
            }
        }
    }
    
    private func getBottomViewData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HomeBottomView>(entityName:"HomeBottomView")
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            var tempDataArray: Array<Dictionary<String, String>> = []
            for info in fetchedObjects{
                let dict = [
                    "itemName" : info.itemName!,
                    "itemImageName" : info.itemImageName!
                ]
                tempDataArray.append(dict)
            }
            bottomView?.dataArray = tempDataArray
            bottomView?.reloadData()
        }
        catch {
            fatalError("查询失败：\(error)")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}

