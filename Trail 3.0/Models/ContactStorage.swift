//
//  ContactStorage.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 12/11/2021.
//

import Foundation
import CoreData

public class ContactStorage: NSManagedObject {
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
    @NSManaged var isEdited: Bool
}

extension ContactStorage {
    static func saveContacts(contacts: [Contact], context: NSManagedObjectContext) {
        for contact in contacts {
            let contactEntity = ContactStorage(context: context)
            
            contactEntity.firstName = contact.name.first
            contactEntity.lastName = contact.name.last
            contactEntity.age = contact.dob.age
            contactEntity.date = contact.dob.date
            contactEntity.city = contact.location.city
            contactEntity.state = contact.location.state
            contactEntity.postcode = contact.location.postcode
            contactEntity.latitude = contact.location.coordinates.latitude
            contactEntity.longitude = contact.location.coordinates.longitude
            contactEntity.cell = contact.cell
            contactEntity.id = contact.id.value
            contactEntity.email = contact.email
            contactEntity.imgMedium = contact.picture.medium
            contactEntity.imgLarge = contact.picture.large
            contactEntity.imgThumb = contact.picture.thumbnail
            contactEntity.isEdited = false
            
        }
        
        ModelManager.sharedManager.saveContext()
    }
}
