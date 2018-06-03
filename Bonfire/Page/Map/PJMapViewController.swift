//
//  PJMapViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/22.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit


class PJMapViewController: PJBaseViewController, PJMapDelegate {
    
    private var mapView: PJMap?
    private var declareButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        self.leftBarButtonItemAction(action: #selector(cancelBarButtonClick))
        self.rigthBarButtonItemAction(action: #selector(redoAnnotation), barButtonSystemItem: .reply)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        mapView = {
            let map = PJMap.init(frame: view.frame)
            map.pjMapDelegate = self
            view.addSubview(map)
            return map
        }()
        
        declareButton = {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: PJSCREEN_HEIGHT, width: PJSCREEN_WIDTH * 0.9, height: 55))
            button.centerX = view.centerX
            button.backgroundColor = UIColor.orange
            button.layer.cornerRadius = 10
            button.setTitle("确定", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.addTarget(self, action: #selector(declareButtonClick), for: .touchUpInside)
            view.addSubview(button)
            return button
        }()
        
    }

    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: {
            // 退出时停止更新用户位置信息
            self.mapView?.stopUpdatingUserLongcationOnBackGround()
        })
    }
    
    @objc private func declareButtonClick() {
        // 发送给实时防护
    }
    
    
    @objc func redoAnnotation() {
        if (mapView?.annotationCoordinateArray?.count)! > 0 {
            let ann = mapView?.annotationCoordinateArray?.last
            mapView?.mapView?.removeAnnotation(ann!)
            mapView?.annotationCoordinateArray?.removeLast()
        }
        if mapView?.annotationCoordinateArray?.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            UIView.transition(with: declareButton!, duration: 0.25, options: UIViewAnimationOptions.curveLinear, animations: {
                self.declareButton?.top = PJSCREEN_HEIGHT
            }, completion: nil)
        }
    }
    
    func pjMap(map: PJMap, annotationCount: Int, touchState: UIGestureRecognizerState) {
        if touchState == .ended && annotationCount > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true;
            UIView.transition(with: declareButton!, duration: 0.25, options: UIViewAnimationOptions.curveLinear, animations: {
                self.declareButton?.bottom = self.view.bottom - (self.declareButton?.height)! - (self.declareButton?.height)! / 2
            }, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
