//
//  ContactStorage.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 12/11/2021.
//

import Foundation
import CoreData

public class ContactStore: NSManagedObject {
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var age: Int
    @NSManaged var date: String
    @NSManaged var city: String
    @NSManaged var state: String
    @NSManaged var postcode: String
    @NSManaged var latitude: String
    @NSManaged var longitude: String
    @NSManaged var cell: String
    @NSManaged var id: String
    @NSManaged var email: String
    @NSManaged var imgMedium: String
    @NSManaged var imgLarge: String
    @NSManaged var imgThumb: String
    
}
