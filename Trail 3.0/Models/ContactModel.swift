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
    let age: Int
    let date: String
    let city: String
    let state: String
    let postcode: String
    let cell: String
    let email: String
    let imgMedium: String
    let imgLarge: String
    let imgThumb: String

    init(
        firstName: String,
        lastName: String,
        age: Int,
        date: String,
        city: String,
        state: String,
        postcode: String,
        cell: String,
        email: String,
        imgMedium: String,
        imgLarge: String,
        imgThumb: String
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.date = date
        self.city = city
        self.state = state
        self.postcode = postcode
        self.cell = cell
        self.email = email
        self.imgMedium = imgMedium
        self.imgLarge = imgLarge
        self.imgThumb = imgThumb
    }
}
