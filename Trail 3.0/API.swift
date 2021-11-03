//
//  API.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 02/11/2021.
//

import Foundation
import UIKit

// MARK: Fetching data from API in final class
// MARK: For lagring, se på forelesningsprosjekt (Studentcounter)
// https://www.youtube.com/watch?v=V2IfBdxjWs4&t=1377s


final class API {
    
    static let shared = API()
    let url = URL(string: "https://randomuser.me/api/?results=100&nat=no")
    
    private init(){}
    
    public func getRandomContacts(completion: @escaping (Swift.Result<[Contact], Error>) -> Void) {
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ContactInfo.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
