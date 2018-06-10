//
//  PJHelper.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/10.
//  Copyright © 2018年 #incloud. All rights reserved.
//
import UIKit
import CoreData

class PJHelper: NSObject {

    class func initCollectionViewData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let itemImgArray = ["home_photo", "home_map", "home_sound", "home_clock", "home_tool", "home_setting"]
        let itemName = [ "紧急相机", "实时共享", "实时录音", "定时保护", "工具箱", "设置"]
        
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
    
    class func initBottomViewData() {
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
    
    class func getCollectionViewData() -> Array<Dictionary<String, String>> {
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
            return tempDataArray
        }
        catch {
            fatalError("查询失败：\(error)")
        }
    }
    
    class func getBottomViewData() -> Array<Dictionary<String, String>> {
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
            return tempDataArray
        }
        catch {
            fatalError("查询失败：\(error)")
        }
    }
    
}
