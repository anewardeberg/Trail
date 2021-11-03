//
//  ContactDetailViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 03/11/2021.
//

import Foundation
import UIKit

class ContactDetailViewController: UIViewController {
    var contact: ContactCellViewModel?
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var showUserOnMapButton: UIButton!
    
    @IBAction func showUserOnMapButtonWasTapped(_ sender: UIButton) {
        print("==== SHOW USER ON MAP")
    }
    
    
    
    
    @IBAction func deleteContactButtonWasTapped(_ sender: Any) {
        //  https://stackoverflow.com/questions/25511945/swift-alert-view-with-ok-and-cancel-which-button-tapped
        let refreshAlert = UIAlertController(title: "Delete contact?", message: "This action cannot be undone.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            print("==== CONTACT DELETED")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("==== ACTION CANCELLED")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = contact {
            contactImageView.loadImage(urlString: contact.imgLarge)
            nameLabel.text = "\(contact.firstName) \(contact.lastName)"
            birthdayLabel.text = "\(contact.age) år (\(contact.date))"
            locationLabel.text = "\(contact.postcode) \(contact.city), \(contact.state)"
            cellLabel.text = "+47 \(contact.cell)"
            mailLabel.text = contact.email
            
            showUserOnMapButton.setTitle("Show \(contact.firstName) on the map", for: .normal)
        }
        
        
    }
}
