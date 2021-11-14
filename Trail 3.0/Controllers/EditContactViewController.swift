//
//  EditContactViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 05/11/2021.
//

import Foundation
import UIKit

//https://developer.apple.com/forums/thread/101483
class EditContactViewController: UIViewController {
    var contact: ContactStorage!
    var activeTextField = UITextField()

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

        if let contact = contact {
            firstNameTextField.placeholder = contact.firstName
            lastNameTextField.placeholder = contact.lastName
            cityTextField.placeholder = contact.city
            emailTextField.placeholder = contact.email
            cellTextField.placeholder = contact.cell
            birthdayDatePicker.date = contact.date.formatISOStringToDate()
        }
        
        
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
        
    
        
        
        #warning("change age dynamically to date picked")

        
        self.navigationController?.popViewController(animated: true)
    }
    
//    https://stackoverflow.com/questions/25232009/calculate-age-from-birth-date-using-nsdatecomponents-in-swift
    func updateBirthday() {
   

        var birthday = birthdayDatePicker.date.formatDateToString(format: "yyyy-MM-dd")
        contact.date = birthday
        print("==== BIRTHDAY")
        print(birthday)
        let timeInterval = birthdayDatePicker.date.timeIntervalSinceNow
        let age = abs(Int(timeInterval / 31556926.0))
        print("==== AGE")
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

//    https://www.codegrepper.com/code-examples/swift/xcode+how+to+know+which+textfield+is+selected
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let activeTextFieldText = self.activeTextField.text {
                    print("Active textfield: \(activeTextField)")
                    print("Active text field's text: \(activeTextFieldText)")
                    return;
              }
        else {
            print("==== SØREN DETTE FUNKET IKKE HELT")
        }
    }
    
//    https://stackoverflow.com/questions/25223407/max-length-uitextfield
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
}
