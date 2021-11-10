//
//  ModelManager.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 10/11/2021.
//

import Foundation
import CoreData

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


