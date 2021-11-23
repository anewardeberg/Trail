import Foundation
import UIKit
import CoreData

class EditContactViewController: UIViewController {
    var contact: ContactStorage!
    var activeTextField = UITextField()
    var context: NSManagedObjectContext!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
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
        firstNameTextField.placeholder = contact.firstName
        lastNameTextField.placeholder = contact.lastName
        cityTextField.placeholder = contact.city
        emailTextField.placeholder = contact.email
        cellTextField.placeholder = contact.cell
        birthdayDatePicker.date = contact.date.toDate(dateFormat:"MM/dd/yyyy")
    }

    @IBAction func saveContactInfoButtonWasTapped(_ sender: Any) {
        if let contactFirstName = self.firstNameTextField.text {
            if contactFirstName != "" {
                contact.firstName = contactFirstName
            }
        }
        if let contactLastName = self.lastNameTextField.text {
            if contactLastName != "" {
                contact.lastName = contactLastName
            }
        }
        if let contactCity = self.cityTextField.text {
            if contactCity != "" {
                contact.city = contactCity
            }
        }
        if let contactEmail = self.emailTextField.text {
            if contactEmail != "" {
                contact.email = contactEmail
            }
        }
        if let contactCell = self.cellTextField.text {
            if contactCell != "" {
                contact.cell = contactCell
            }
        }
        
        updateBirthday()
        contact.isEdited = true
        try? context.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateBirthday() {
        let birthday = birthdayDatePicker.date.toString(format: "MM/dd/yyyy")
        contact.date = birthday
        let timeInterval = birthdayDatePicker.date.timeIntervalSinceNow
        let age = abs(Int(timeInterval / 31556926.0))
        contact.age = age
        try? context.save()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField.endEditing(true)
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
            self.activeTextField = textField
       }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            return false
        }
    }
}
