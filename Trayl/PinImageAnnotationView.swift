//
//  PinImageAnnotationView.swift
//  Trayl
//
//  Created by Aniruddha Nadkarni on 9/12/15.
//  Copyright © 2015 Aniruddha Nadkarni. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class PinImageAnnotationView: NSObject {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var lost:Bool?
    var contact:String?
    var index:Int?
    
    init(myCoordinate: CLLocationCoordinate2D, title: String, lost: Bool, contact: String) {
        self.coordinate = myCoordinate
        self.title = title
        self.lost = lost
        self.contact = contact
    }
    
    
}
