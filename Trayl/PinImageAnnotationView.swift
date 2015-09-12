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

class PinImageAnnotationView: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pinImage: UIImage
    
    init(myCoordinate: CLLocationCoordinate2D, myPinImage: UIImage) {
        self.coordinate = myCoordinate
        self.pinImage = myPinImage
        
    }
    
    
}
