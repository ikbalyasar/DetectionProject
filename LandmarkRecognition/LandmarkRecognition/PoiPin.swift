//
//  PoiPin.swift
//
//  Created by Muhammet İkbal Yaşar 
//

import UIKit
import MapKit

class PoiPin: NSObject, MKAnnotation{

    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.coordinate = coordinate
    }
    
}
