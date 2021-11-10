// This file was generated from JSON Schema using quicktype

import Foundation

struct ContactInfo: Codable {
    let results: [Contact]
    let info: Info
}


struct Info: Codable {
    let seed: String
}


struct Contact: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let dob: Dob
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String
}

struct Dob: Codable {
    let date: String
    let age: Int
}

struct ID: Codable {
    let name: String
    #warning("implement id value in contactmodel")
//    let value: String
}

struct Location: Codable {
    let city, state, country: String
    let postcode: String
    let coordinates: Coordinates
}

struct Coordinates: Codable {
    let latitude, longitude: String
}

struct Name: Codable {
    let first: String
    let last: String
}

struct Picture: Codable {
    let large, medium, thumbnail: String
}

