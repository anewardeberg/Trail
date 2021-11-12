//
//  ModelManager.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 10/11/2021.
//

import Foundation
import CoreData

class ModelManager: NSObject {
    
    class var sharedManager : ModelManager {
           struct Singleton {
               static let instance = ModelManager()
           }
           return Singleton.instance
       }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Trail_3_0")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// MARK: - alt av kode fra core data som blir lagt i AppDelegate skal legges her

//MARK: init(entity: ) brukes for å inserte inn i core data
// har bare 1 NSMAnagedObjectContext
// entity må være det samme som i models filen.

//let student = Student(entity: NSEntityDescription.entity(forEntityName: entityName, in: NSManagedObjectContext?))

// MARK: Dersom man endrer navn på attributter: Erase all content and data. wiper alt i databasen 
// MARK Sjekk bilde tatt fra forelesning: Gjøre om jsonobjekter til Core Data objekter. DEMO PROSJEKT STUDENT PÅ GITHUB. 

// MARK: godt tips!!! <3
// KAN lagre url, men kanskje smartest å lagre selve bildet når man først henter det ned, men IKKE hvis man ikke vil at core data strukturen ikke gjenspeiler json fil fra api 100%
// går fint, men må skrive en workaround
// lagre bildet i en fil. finnes bildet til personen? når man trenger den

// google når man skal gjøre insert
// bare save context holder ikke

// persisteringsforelesning: Hvordan gjøre string til en fil? -> Hvordan gjøre data til en fil?


//MARK: - testing
// kan bruke core data i test, men da må man lage sin egen contextManager og persistentStore Container
// husk import CoreData
// se studentprosjektet på git
//XCTAssertTrue(student.hasBirthday(date: Date()))
// lag en persistent container i testene


