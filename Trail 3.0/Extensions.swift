import Foundation
import UIKit


// https://www.youtube.com/watch?v=OTcQnf6ziew


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
    
//    https://newbedev.com/is-a-date-in-same-week-month-year-of-another-date-in-swift
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

//https://stackoverflow.com/questions/29055654/swift-check-if-date-is-in-next-week-month-isdateinnextweek-isdateinnext
extension Calendar {
    private var currentDate: Date { return Date() }
    func isDateInThisWeek(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
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

