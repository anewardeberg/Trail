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
                        var contactCoordinate = CLLocationCoordinate2D(latitude: contact.latitude.toDouble(), longitude: contact.longitude.toDouble())
                        
                        var contactName = "\(contact.firstName) \(contact.lastName)"
                        
                        self.addCustomPin(coordinates: contactCoordinate, title: contactName, id: contact.id, uri: contact.imgThumb)
                    }
                } catch {
                    print(error)
                    
                    let alert = UIAlertController(title: "Could not fetch contacts", message: "Try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
            
            
        }
        
        if let contactLatitude = contactLatitude {
            print(contactLatitude)
            print(contactLongitude)
            
            let contactCoordinates = CLLocationCoordinate2D(latitude: contactLatitude.toDouble(), longitude: contactLongitude?.toDouble() ?? 0)
            let region = MKCoordinateRegion( center: contactCoordinates, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
            map.setRegion(region, animated: true)
            addCustomPin(coordinates: contactCoordinates, title: " ", id: " ", uri: contactImageURL)
        }
        
    }
    
    //https://www.youtube.com/watch?v=DHpL8yz6ot0&t=619s
    
    func addCustomPin(coordinates: CLLocationCoordinate2D, title: String, id: String, uri: String) {
        let pin = ContactAnnotation(title: title, subtitle: "", coordinate: coordinates)
        
        pin.id = id
        pin.uri = uri
        
        map.addAnnotation(pin)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as? ContactAnnotation
        
        if control == view.rightCalloutAccessoryView {
            for contact in contactList {
                if(contact.id == annotation?.id) {
                    selectedContact = contact
                }
            }
            
            performSegue(withIdentifier: "fromMapToContactDetail", sender: self)
        }
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if let annotation = annotation as? ContactAnnotation {
            let identifier = "custom"
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            getData(from: annotation.uri!) { (data, response, error) in
                guard let data = data, error == nil else {
                    debugPrint("No date derived from uri: \(annotation.uri ?? "nil")")
                    return
                }
                
                DispatchQueue.main.async() {
                    annotationView?.image = UIImage(data: data)
                }
            }
            
            annotationView?.canShowCallout = true
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
            return annotationView
        }
    
        return nil
    }
    
    //    https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: completion).resume()
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
