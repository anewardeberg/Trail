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
    
    
    @IBOutlet weak var map: MKMapView!
    var contactModels = [ContactModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        map.delegate = self
        if (tabBarController?.selectedIndex == 1) {
            let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
            
            ModelManager.sharedManager.persistentContainer.viewContext.perform {
                do {
                    let results = try fetchRequest.execute()
                    self.contactList = results
                    print("==== FETCHED CONTACT LIST FROM CORE DATA")
                    var contactLocation: [MKPointAnnotation] = []
                    for contact in self.contactList {
                        var contactCoordinate = CLLocationCoordinate2D(latitude: contact.latitude.toDouble(), longitude: contact.longitude.toDouble())
                        var contactName = "\(contact.firstName) \(contact.lastName)}"
                        addAnnotation(coordinates: contactCoordinate, title: contactName)
                        contactLocation.append(pin)
                    
                    }
                    
                    self.map.addAnnotations(contactLocation)
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
            map.setRegion(region, animated: true)
            let contactLocation = ContactLocation(name: "User", coordinate: contactCoordinates)
            map.addAnnotation(contactLocation)
        }
        
        func addAnnotation(coordinates: CLLocationCoordinate2D, title: String) {
            let pin = MKPointAnnotation()
            pin.title = title
            pin.coordinate = coordinates
            map.addAnnotation(pin)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var annotationView: MKAnnotationView?
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "custom")
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = pin
            }
            
            return annotationView
        }
        
        
        
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
