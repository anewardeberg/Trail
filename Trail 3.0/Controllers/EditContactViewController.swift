//
//  EditContactViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 05/11/2021.
//

import Foundation
import UIKit

class EditContactViewController: UIViewController {
    var contact: ContactModel?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        if let contact = contact {
            firstNameTextField.placeholder = contact.firstName
            lastNameTextField.placeholder = contact.lastName
            cityTextField.placeholder = contact.city
            emailTextField.placeholder = contact.email
            cellTextField.placeholder = contact.cell
            birthdayDatePicker.date = contact.date.formatISOStringToDate()
        }
    }
}
