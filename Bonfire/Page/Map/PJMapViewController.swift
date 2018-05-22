//
//  PJMapViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/22.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import MapKit

class PJMapViewController: UIViewController, MKMapViewDelegate {

    private var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Cancel"),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(cancelBarButtonClick))
        
        mapView = {
            let map = MKMapView.init(frame: view.frame)
            map.showsUserLocation = true
            map.userTrackingMode = MKUserTrackingMode.follow
//            map.pausesLocationUpdatesAutomatically = false
//            map.allowsBackgroundLocationUpdates = true
            view.addSubview(map)
            return map
        }()
    }

    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
