import Foundation
import UIKit
import CoreData

class ContactDetailViewController: UIViewController {
    var managedObjectContext : NSManagedObjectContext?
    var contact: ContactStorage!
    var contactLatitude: String?
    var contactLongitude: String?
    var contactImageURL: String?
    var contactHasBirthday = false
    let birthdayEmojiArray = ["🎉", "⭐️", "🎂", "🧁", "🎊"]
    let context = ModelManager.sharedManager.persistentContainer.viewContext
    
    
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

        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
        fetchRequest.predicate = NSPredicate(format: "id == %@", contact.id)
        
        context.perform {
            do {
                let result = try fetchRequest.execute()
                self.contact = result[0]
            } catch {
                print(error)
                let alert = UIAlertController(title: "Could not fetch contact", message: "Try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
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
        locationLabel.text = "\(contact.postcode) \(contact.city), \(contact.state)"
        cellLabel.text = "+47 \(contact.cell)"
        mailLabel.text = contact.email
        showUserOnMapButton.setTitle("Show \(contact.firstName) on the map", for: .normal)
        
        
        
    }
    
    func checkBirthday() {
        let birthday = contact?.date.toDate(dateFormat: "MM/dd/yyyy")
        if contact != nil {
            let date = Date()
            if (birthday!.hasSame(.weekOfYear, as: date)) {
                birthdayEmojiLabel.alpha = 1
                contact!.hasBirthday = true
                try? context.save()
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
        let refreshAlert = UIAlertController(title: "Delete contact?", message: "This action cannot be undone.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            self.context.delete(self.contact)
            try? self.context.save()
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
            destinationVC.context = context
            destinationVC.contact = contact
            
        }
    }
    
}

