//
//  ContactDetailViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 03/11/2021.
//

import Foundation
import UIKit

class ContactDetailViewController: UIViewController {
    var contact: ContactStorage?
    var contactLatitude: String?
    var contactLongitude: String?
    var contactImageURL: String?
    var contactHasBirthday = false
    
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var showUserOnMapButton: UIButton!
    
    
    override func viewDidLoad() {
        print("==== [CONTACT DETAIL] VIEW DID LOAD")
        super.viewDidLoad()
        if let contact = contact {
            
            contactLatitude = contact.latitude
            contactLongitude = contact.longitude
            contactImageURL = contact.imgMedium
            
            
            contactImageView.loadImage(urlString: contact.imgLarge)
            nameLabel.text = "\(contact.firstName) \(contact.lastName)"
            birthdayLabel.text = "\(contact.age) år (\(contact.date))"
            print("==== [CONTACT DETAIL] Contact Birthday: \(contact.date)")
            locationLabel.text = "\(contact.postcode) \(contact.city), \(contact.state)"
            cellLabel.text = "+47 \(contact.cell)"
            mailLabel.text = contact.email
            showUserOnMapButton.setTitle("Show \(contact.firstName) on the map", for: .normal)
        }
        
        
    }
    
    func viewWillAppear() {
        print("==== [CONTACT DETAIL] VIEW DID APPEAR")
        if let contact = contact {
            
            contactLatitude = contact.latitude
            contactLongitude = contact.longitude
            contactImageURL = contact.imgMedium
            
            
            contactImageView.loadImage(urlString: contact.imgLarge)
            nameLabel.text = "\(contact.firstName) \(contact.lastName)"
            birthdayLabel.text = "\(contact.age) år (\(contact.date))"
            print("==== [CONTACT DETAIL] Contact Birthday: \(contact.date)")
            locationLabel.text = "\(contact.postcode) \(contact.city), \(contact.state)"
            cellLabel.text = "+47 \(contact.cell)"
            mailLabel.text = contact.email
            showUserOnMapButton.setTitle("Show \(contact.firstName) on the map", for: .normal)
        }
        
        
    }
    
    func checkBirthday() {
        let birthday = contact?.date.toDate(dateFormat: "MM/dd/yyyy")
        if contact != nil {
            if Calendar.current.isDateInThisWeek(birthday!) {
                
            }
        }
    }
    
    @IBAction func showUserOnMapButtonWasTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showUserOnMap", sender: self)
    }
    
    
    @IBAction func editContactButtonWasTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToEditContact", sender: self)
    }
    
    
    @IBAction func deleteContactButtonWasTapped(_ sender: UIButton) {
        //  https://stackoverflow.com/questions/25511945/swift-alert-view-with-ok-and-cancel-which-button-tapped
        let refreshAlert = UIAlertController(title: "Delete contact?", message: "This action cannot be undone.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            print("==== [CONTACT DETAIL] CONTACT DELETED")
            ModelManager.sharedManager.persistentContainer.viewContext.delete(self.contact!)
            ModelManager.sharedManager.saveContext()
            self.navigationController?.popViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserOnMap" {
            let destinationVC = segue.destination as! MapViewController
            if contact != nil {
                destinationVC.contactLatitude = contactLatitude
                destinationVC.contactLongitude = contactLongitude
                destinationVC.contactImageURL = contactImageURL
            }
        }
        
        if segue.identifier == "goToEditContact" {
            let destinationVC = segue.destination as! EditContactViewController
            if let contact = contact {
                destinationVC.contact = contact
            }
        }
    }
    
}

