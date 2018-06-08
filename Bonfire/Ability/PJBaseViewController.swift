//
//  PJBaseViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/3.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJBaseViewController: UIViewController {

    public var navBar: UINavigationBar?
    public var navItem: UINavigationItem?
    public var isTitleLarge: Bool? {
        didSet {
            changePreferLargeTitles(isLarge: isTitleLarge!)
        }
    }
    
    public var isBackWithLeftBarButtonItem: Bool? {
        didSet {
            changeLeftBarButtonItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView(){
        navBar = navigationController?.navigationBar
        navItem = navigationItem
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func changeLeftBarButtonItem() {
        leftBarButtonItemAction(action: #selector(pop), iconName: "back")
    }
    
    private func changePreferLargeTitles(isLarge: Bool) {
        if isLarge {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    public func leftBarButtonItemAction(action: Selector!) {
        navItem?.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Cancel"),
                                          style: .done,
                                          target: self,
                                          action: action)
    }
    
    public func leftBarButtonItemAction(action: Selector, iconName: String) {
        navItem?.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: iconName),
                                                          style: .plain, target: self, action: action)
    }
    
    public func rigthBarButtonItemAction(action: Selector!, barButtonSystemItem: UIBarButtonSystemItem) {
        navItem?.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: barButtonSystemItem,
                                                                 target: self, action: action)

    }
    
    public func rightBarButtonItemAction(action: Selector, iconName: String) {
        navItem?.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: iconName),
                                                          style: .plain, target: self, action: action)
    }
    
    public func rightBatButtonItemAction(action: Selector, title: String) {
        navItem?.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain,
                                                           target: self, action: action)
    }
    
    @objc private func pop() {
        navigationController?.popViewController(animated: true)
    }
}

