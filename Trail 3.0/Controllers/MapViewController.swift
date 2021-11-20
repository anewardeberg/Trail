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
    var contactImageURL: String!
    var selectedContact: ContactStorage?
    var selectedContactCoordinates: CLLocationCoordinate2D?
    
    var contactList = [ContactStorage]()
    
    
    @IBOutlet weak var map: MKMapView!
    var contactModels = [ContactModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (tabBarController?.selectedIndex == 1) {
            let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
            
            ModelManager.sharedManager.persistentContainer.viewContext.perform {
                do {
                    let results = try fetchRequest.execute()
                    self.contactList = results
                    print("==== FETCHED CONTACT LIST FROM CORE DATA")
                    for contact in self.contactList {
                        self.contactImageURL = contact.imgThumb
                        var contactCoordinate = CLLocationCoordinate2D(latitude: contact.latitude.toDouble(), longitude: contact.longitude.toDouble())
                        var contactName = "\(contact.firstName) \(contact.lastName)"
                        self.addCustomPin(coordinates: contactCoordinate, title: contactName)
                    }
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
            addCustomPin(coordinates: contactCoordinates, title: " ")
        }
        
    }
    
    //https://www.youtube.com/watch?v=DHpL8yz6ot0&t=619s
    
    func addCustomPin(coordinates: CLLocationCoordinate2D, title: String) {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedContactCoordinates = view.annotation?.coordinate
        if control == view.rightCalloutAccessoryView {
            for contact in contactList {
                var contactLocation = CLLocationCoordinate2D(latitude: contact.latitude.toDouble(), longitude: contact.longitude.toDouble())
                if(selectedContactCoordinates?.latitude == contactLocation.latitude && selectedContactCoordinates?.longitude == contactLocation.longitude) {
                    selectedContact = contact
                }
            }
            performSegue(withIdentifier: "fromMapToContactDetail", sender: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            //            https://stackoverflow.com/questions/33053832/swift-perform-segue-from-map-annotation
            var rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            rightButton.title(for: UIControl.State.normal)
            
            annotationView!.rightCalloutAccessoryView = rightButton as! UIView
        } else {
            annotationView?.annotation = annotation
        }
        
        getData(from: URL(string: contactImageURL)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                annotationView?.image = UIImage(data: data)
            }
        }
        
        return annotationView
    }
    
    //    https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMapToContactDetail" {
            let destinationVC = segue.destination as! ContactDetailViewController
            if let selectedContact = selectedContact {
                destinationVC.contact = selectedContact
            }
        }
    }
}
