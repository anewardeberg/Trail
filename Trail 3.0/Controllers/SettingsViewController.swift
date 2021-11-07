//
//  SettingsViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 04/11/2021.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var apiSeedTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiSeedTextField.delegate = self
        apiSeedTextField.placeholder = "Current seed: \(API.shared.seed)"
        
//      https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        apiSeedTextField.endEditing(true)
        print(apiSeedTextField.text!)
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
        API.shared.setApiSeed(seedInput: textField.text!)
        textField.text = ""
        textField.placeholder = "Current seed: \(API.shared.seed)"
        tabBarController?.selectedIndex = 0
//        self.performSegue(withIdentifier: "upDateSeedAndGoToContactList", sender: self)
    }
    
}
