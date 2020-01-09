//
//  User.swift
//  FriendFace
//
//  Created by Jules Lee on 1/10/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID
    var name: String
    var age: Int16
    var company: String
    var friends: [Friend]
    
    static func fetch() -> [User] {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")
        let request = URLRequest(url: url!)
        
        var users: [User] = [User]()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError("Network error: " + error.localizedDescription)
            }
            guard let response = response as? HTTPURLResponse else {
                fatalError("Not a HTTP response")
            }
            guard response.statusCode >= 200, response.statusCode < 300 else {
                fatalError("Invalid HTTP status code")
            }
            guard let data = data else {
                fatalError("No HTTP data")
            }
            
            if let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                users = decodedUsers
                semaphore.signal()
            }
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return users
    }
}
