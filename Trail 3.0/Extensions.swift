//
//  Extensions.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 02/11/2021.
//

import Foundation
import UIKit


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
}

