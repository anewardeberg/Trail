import Foundation
import UIKit
import CoreData

//https://developer.apple.com/forums/thread/101483
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
#warning("alert user")
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
    
//    https://stackoverflow.com/questions/25232009/calculate-age-from-birth-date-using-nsdatecomponents-in-swift
    func updateBirthday() {
        let birthday = birthdayDatePicker.date.toString(format: "MM/dd/yyyy")
        contact.date = birthday
        print("==== [EDIT CONTACT] BIRTHDAY")
        print(birthday)
        let timeInterval = birthdayDatePicker.date.timeIntervalSinceNow
        let age = abs(Int(timeInterval / 31556926.0))
        print("==== [EDIT CONTACT] AGE")
        print(age)
        contact.age = age
        ModelManager.sharedManager.saveContext()
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
    
//    https://stackoverflow.com/questions/25223407/max-length-uitextfield
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
}
