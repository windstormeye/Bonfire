//
//  PJMapView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/30.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol PJMapDelegate {
    func pjMap(map: PJMap, annotationCount: Int, touchState: UIGestureRecognizerState)
}

class PJMap: UIView, MKMapViewDelegate, CLLocationManagerDelegate {

    private(set) var mapView: MKMapView?
    private var locationManager: CLLocationManager?
    private var geocide: CLGeocoder?
    
    public var pjMapDelegate: PJMapDelegate?
    public var annotationCoordinateArray: Array<MKPointAnnotation>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
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
            let map = MKMapView.init(frame: self.frame)
            map.delegate = self
            map.isRotateEnabled = true
            map.showsUserLocation = true
            map.userTrackingMode = MKUserTrackingMode.followWithHeading
            self.addSubview(map)
            
            let longPress = UILongPressGestureRecognizer.init(target: self,
                                                              action: #selector(mapViewLongPress(sender:)))
            map.addGestureRecognizer(longPress)
            
            return map
        }()
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
        
        if sender.state == .ended {
            pjMapDelegate?.pjMap(map: self, annotationCount: (annotationCoordinateArray?.count)!, touchState: .ended)
        }
    }
    
    public func stopUpdatingUserLongcationOnBackGround() {
        locationManager?.stopUpdatingLocation()
    }
}
