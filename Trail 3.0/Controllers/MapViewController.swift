//
//  MapViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 03/11/2021.
//
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate,  CLLocationManagerDelegate {
    
    var contactLatitude: String?
    var contactLongitude: String?
    var contactImageURL: String?
    
    @IBOutlet weak var mapView: MKMapView!
    var contactModels = [ContactModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        if (tabBarController?.selectedIndex == 1) {
            API.shared.getRandomContacts{ [weak self] result in
                 switch result {
                 case .success(let contacts):
                      self?.contactModels = contacts.compactMap({
                           ContactModel(
                                firstName: $0.name.first,
                                lastName: $0.name.last,
                                age: $0.dob.age,
                                date: $0.dob.date,
                                city: $0.location.city,
                                state: $0.location.state,
                                postcode: $0.location.postcode,
                                latitude: $0.location.coordinates.latitude,
                                longitude: $0.location.coordinates.latitude,
                                cell: $0.cell,
                                email: $0.email,
                                imgMedium: $0.picture.medium,
                                imgLarge: $0.picture.large,
                                imgThumb: $0.picture.thumbnail

                           )})

                 case .failure(let error):
                      print(error)
                 }
                
                var contactLocations: [ContactLocation] = []
                for contactModel in self!.contactModels {
                    var contactCoordinates = CLLocationCoordinate2D(latitude: contactModel.latitude.toDouble(), longitude: contactModel.longitude.toDouble())
                      contactLocations.append(ContactLocation(name: contactModel.firstName, coordinate: contactCoordinates))

                }
                self!.mapView.addAnnotations(contactLocations)
                
            }


    
        }
        // Custom Map Annotation Pin
        // https://stackoverflow.com/questions/38274115/ios-swift-mapkit-custom-annotation
        
        if let contactLatitude = contactLatitude {
            let contactCoordinates = CLLocationCoordinate2D(latitude: contactLatitude.toDouble(), longitude: contactLongitude?.toDouble() ?? 0)
            let region = MKCoordinateRegion( center: contactCoordinates, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
            let contactLocation = ContactLocation(name: "User", coordinate: contactCoordinates)
    //                mapView.setCenter(contactCoordinates, animated: true)
                    mapView.addAnnotation(contactLocation)
                    mapView.addAnnotations([contactLocation])
            
        }
        
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
