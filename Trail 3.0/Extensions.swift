//
//  Extensions.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 02/11/2021.
//

import Foundation
import UIKit
import CoreData


// https://www.youtube.com/watch?v=OTcQnf6ziew


extension UIImageView {
    func loadImage(urlString : String) {
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data  = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadImage2(urlString: String) {
        let task = URLSession.shared.dataTask(with: URL.init(string: urlString)!) { (data, response, error) in
            print(error)
            print(response)
            
            if let image = UIImage(data: data!) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        task.resume()
    }
}
//https://stackoverflow.com/questions/52555913/save-complex-json-to-core-data-in-swift
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.contactInfo[.context] = context
    }
}

extension Date {
    func formatDateToString(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func checkBirthdayWeek() {
        
    }
}

extension String {
    func formatISOStringToDate() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: self)!
        return date
    }
     
    func toDouble() -> Double {
        let double = Double(self)!
        return double
    }
    
}

// https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

