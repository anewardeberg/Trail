//
//  SettingsViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 04/11/2021.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var apiSeedTextField: UITextField!
    var contactList = [ContactStorage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiSeedTextField.delegate = self
        apiSeedTextField.placeholder = "Current seed: \(API.shared.seed)"
        
        //      https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
        
        ModelManager.sharedManager.persistentContainer.viewContext.perform {
            do {
                let results = try fetchRequest.execute()
                self.contactList = results
                print("==== [SETTINGS] CONTACTS FETCHED")
            } catch {
                print(error)
                let alert = UIAlertController(title: "Could not fetch contacts", message: "Try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func saveSeedButtonWasTapped(_ sender: Any) {
        apiSeedTextField.endEditing(true)
        let apiSeedString = apiSeedTextField.text
        let trimmedApiSeedString = apiSeedString?.removeWhitespaces()
        print("==== [SETTINGS]")
        print(trimmedApiSeedString)
        if(trimmedApiSeedString == "") {
            let alert = UIAlertController(title: "Error saving seed:", message: "Invalid or no input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            API.shared.setApiSeed(seedInput: trimmedApiSeedString!)
            apiSeedTextField.text = ""
            apiSeedTextField.placeholder = "Current seed: \(API.shared.seed)"
            
            for contact in contactList {
                if(contact.isEdited == false) {
                    ModelManager.sharedManager.persistentContainer.viewContext.delete(contact)
                    print("==== [SETTINGS] CONTACT DELETED")
                    ModelManager.sharedManager.saveContext()
                }
            }
            API.shared.getRandomContacts{ result in
                switch result {
                case .success(let contacts):
                    DispatchQueue.main.async {
                        ContactStorage.saveContacts(contacts: contacts, context: ModelManager.sharedManager.persistentContainer.viewContext)
                        print("==== [SETTINGS] FETCHED AND SAVED NEW CONTACTS")
                    }
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not fetch contacts", message: "Check your internet connection,", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            let alert = UIAlertController(title: "Seed saved successfully!", message: "Seed: \(API.shared.seed)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Current seed: \(API.shared.seed)"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Current seed: \(API.shared.seed)"
    }
    
}
