import Foundation
import UIKit

extension UIImageView {
    func loadImage(urlString: String) {
        let task = URLSession.shared.dataTask(with: URL.init(string: urlString)!) { (data, response, error) in
            if let image = UIImage(data: data!) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        task.resume()
    }
}

extension Date {
    func toString(format: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.string(from: self)
    }
    
    func hasSame(_ components: Calendar.Component..., as date: Date, using calendar: Calendar = .autoupdatingCurrent) -> Bool {
                 return components.filter { calendar.component($0, from: date) != calendar.component($0, from: self) }.isEmpty
        }
}

extension String {
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        if let stringAsDate = dateFormatter.date(from: self) {
            return stringAsDate
        } else {
            print("could not convert to Date")
            return Date()
        }
    }
    
    func removeWhitespaces() -> String {
        return self.components(separatedBy: .whitespaces).joined(separator: "")
    }
    
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

