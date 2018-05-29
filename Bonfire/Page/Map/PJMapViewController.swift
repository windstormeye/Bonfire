//
//  PJMapViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/22.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PJMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    private var mapView: MKMapView?
    private var locationManager: CLLocationManager?
    private var geocide: CLGeocoder?
    
    private var annotationCoordinateArray: Array<MKPointAnnotation>?
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .reply, target: self, action: #selector(redoAnnotation))
        
        annotationCoordinateArray = []
        
        geocide = {
            let ge = CLGeocoder.init()
            return ge
        }()
        
        locationManager = {
            let manager = CLLocationManager.init()
            manager.allowsBackgroundLocationUpdates = true
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            manager.distanceFilter = 50
            return manager
        }()
        
        mapView = {
            let map = MKMapView.init(frame: view.frame)
            map.delegate = self
            map.isRotateEnabled = true
            map.showsUserLocation = true
            map.userTrackingMode = MKUserTrackingMode.followWithHeading
//            map.pausesLocationUpdatesAutomatically = false
//            map.allowsBackgroundLocationUpdates = true
            view.addSubview(map)

            let longPress = UILongPressGestureRecognizer.init(target: self,
                                                              action: #selector(mapViewLongPress(sender:)))
            map.addGestureRecognizer(longPress)
            
            return map
        }()
    }

    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        print("\(String(describing: userLocation.coordinate.longitude)) : \(String(describing: userLocation.coordinate.latitude))")
        
    }
    
    @objc func mapViewLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            PJTapic.select()
            
            let location = sender.location(in: mapView)
            let coordinate = mapView?.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation.init()
            annotation.coordinate = coordinate!
            
            annotationCoordinateArray?.append(annotation)
            mapView?.addAnnotation(annotation)
        }
    }
    
    @objc func redoAnnotation() {
        if (annotationCoordinateArray?.count)! > 0 {
            let ann = annotationCoordinateArray?.last
            mapView?.removeAnnotation(ann!)
            annotationCoordinateArray?.removeLast()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
