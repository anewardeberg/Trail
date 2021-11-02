//
//  ContactModel.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 02/11/2021.
//

import UIKit
class ContactCellViewModel{
    let firstName: String
    let lastName: String
    let imgMedium: String
    let imgLarge: String
    let imgThumb: String

    init(
        firstName: String,
        lastName: String,
        imgMedium: String,
        imgLarge: String,
        imgThumb: String
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.imgMedium = imgMedium
        self.imgLarge = imgLarge
        self.imgThumb = imgThumb
    }
}
