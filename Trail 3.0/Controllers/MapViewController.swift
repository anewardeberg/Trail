//
//  MapViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 03/11/2021.
//
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate,  CLLocationManagerDelegate {
    
    var contactLatitude: String?
    var contactLongitude: String?
    var contactImageURL: String?
    
    var contactList = [ContactStorage]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    var contactModels = [ContactModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        if (tabBarController?.selectedIndex == 1) {
            let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
            
            ModelManager.sharedManager.persistentContainer.viewContext.perform {
                do {
                    let results = try fetchRequest.execute()
                    self.contactList = results
                    print("==== FETCHED CONTACT LIST FROM CORE DATA")
                    var contactLocation: [ContactLocation] = []
                    for contact in self.contactList {
                        var contactCoordinate = CLLocationCoordinate2D(latitude: contact.latitude.toDouble(), longitude: contact.longitude.toDouble())
                          contactLocation.append(ContactLocation(name: contact.firstName, coordinate: contactCoordinate))
                        print("==== CONTACT LATITUDE")
                        print(contact.latitude)
                    }
                    
                    self.mapView.addAnnotations(contactLocation)
                } catch {
                    print(error)
#warning("alert user")
                }
            }


            
                
        }
        
        if let contactLatitude = contactLatitude {
            print(contactLatitude)
            print(contactLongitude)
            let contactCoordinates = CLLocationCoordinate2D(latitude: contactLatitude.toDouble(), longitude: contactLongitude?.toDouble() ?? 0)
            let region = MKCoordinateRegion( center: contactCoordinates, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
            mapView.setRegion(region, animated: true)
            let contactLocation = ContactLocation(name: "User", coordinate: contactCoordinates)
            mapView.addAnnotation(contactLocation)
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
