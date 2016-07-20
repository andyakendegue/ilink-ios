//
//  MarkerAnnotations.swift
//  ilink
//
//  Created by Capp Andy MIGOUMBI AKENDEGUE on 30/06/2016.
//  Copyright © 2016 Capp Andy MIGOUMBI AKENDEGUE. All rights reserved.
//

import UIKit
import MapKit

class MarkerAnnotations: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    var eta: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
