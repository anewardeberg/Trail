//
//  ContactDetailViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 03/11/2021.
//

import Foundation
import UIKit
import CoreData

class ContactDetailViewController: UIViewController {
    var managedObjectContext : NSManagedObjectContext?
    var contact: ContactStorage?
    var contactLatitude: String?
    var contactLongitude: String?
    var contactImageURL: String?
    var contactHasBirthday = false
    let birthdayEmojiArray = ["🎉", "⭐️", "🎂", "🧁", "🎊"]
    
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var showUserOnMapButton: UIButton!
    @IBOutlet weak var birthdayEmojiLabel: UILabel!
    
    
    override func viewDidLoad() {
        birthdayEmojiLabel.alpha = 0
    
        print("==== [CONTACT DETAIL] VIEW DID LOAD")
        super.viewDidLoad()
        if let contact = contact {
            checkBirthday()
            if(contact.hasBirthday) {
                rainBirthdayEmojis()
            }
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
            checkBirthday()
            if(contact.hasBirthday) {
                rainBirthdayEmojis()
            }
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
            let date = Date()
            print(date)
            if (birthday!.hasSame(.weekOfYear, as: date)) {
                birthdayEmojiLabel.alpha = 1
                contact!.hasBirthday = true
                ModelManager.sharedManager.saveContext()
            }
        }
    }
    
    func rainBirthdayEmojis() {
        for _ in 1...20 {
            let randomInt = Int.random(in: 1..<400)
            let randomDuration = Double.random(in: 1...4)
            let animateEmoji = UILabel.init(frame: CGRect.init(x: randomInt, y: 0, width: 40, height: 40))
            animateEmoji.font = UIFont.systemFont(ofSize: 40)
            animateEmoji.transform = animateEmoji.transform.scaledBy(x: 1, y: 1);
            animateEmoji.text = birthdayEmojiArray.randomElement()
            view.addSubview(animateEmoji)
            
            UIView.animate(withDuration: randomDuration,
                           delay: 0,
                           options: [.curveEaseIn, .repeat, .beginFromCurrentState],
                           animations: {
                var frame = animateEmoji.frame
                animateEmoji.transform = animateEmoji.transform.scaledBy(x: 0.1, y: 0.1);
                frame.origin.y += 700
                animateEmoji.frame = frame

                
            }, completion: nil)
            
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

