import UIKit
import CoreData


class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var context = ModelManager.sharedManager.persistentContainer.viewContext
    
    @IBOutlet weak var apiSeedTextField: UITextField!
    var contactList = [ContactStorage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiSeedTextField.delegate = self
        apiSeedTextField.placeholder = "Current seed: \(API.shared.seed)"
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
        
        context.perform {
            do {
                let results = try fetchRequest.execute()
                self.contactList = results
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
                    context.delete(contact)
                }
            }
            
            try? context.save()
            
            API.shared.getRandomContacts{ result in
                switch result {
                case .success(let contacts):
                    DispatchQueue.main.async {
                        ContactStorage.saveContacts(contacts: contacts, context: self.context)
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
