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
    var imgURL: String
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
    
    getData(from: URL(string: imgURL)!) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            annotationView?.image = UIImage(data: data)
        }
    }
    
    //    https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

