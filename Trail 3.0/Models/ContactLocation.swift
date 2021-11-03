//
//  ContactLocation.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 03/11/2021.
//

import Foundation
import MapKit

//https://www.oodlestechnologies.com/blogs/Display-Multiple-annotation-in-Map-Swift/
class ContactLocation: NSObject, MKAnnotation {
    var name: String?
//    var imgURL: String
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
//        self.imgURL = imgURL
        self.coordinate = coordinate
    }
}
