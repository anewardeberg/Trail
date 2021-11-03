// This file was generated from JSON Schema using quicktype

import Foundation

// MARK: - Contact
struct ContactInfo: Codable {
    let results: [Contact]
    let info: Info
}

// MARK: - Info
struct Info: Codable {
    let seed: String
}

// MARK: - Result
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

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int
}

// MARK: - ID
struct ID: Codable {
    let name: String
//    let value: String
}

// MARK: - Location
struct Location: Codable {
    let city, state, country: String
    let postcode: String
    let coordinates: Coordinates
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Name
struct Name: Codable {
    let first: String
    let last: String
}
// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}

