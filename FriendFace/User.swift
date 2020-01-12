//
//  User.swift
//  FriendFace
//
//  Created by Jules Lee on 1/10/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import CoreData
import SwiftUI

struct User: Codable, Identifiable {
    var id: UUID
    var name: String
    var age: Int16
    var company: String
    var friends: [Friend]
    
    static func fetch() -> [User] {
        
        let cdUsers = User.fetchCoreData()
        
        var users: [User] = [User]() {
            didSet {
                if cdUsers.count == 0 {
                    DispatchQueue.main.async {
                        User.saveToCoreData(users: users)
                    }
                }
            }
        }
        
        if cdUsers.count > 0 {
            users = cdUsers
            print("from cdusers")
        } else {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")
            let request = URLRequest(url: url!)
            
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
                    print("from users")
                    semaphore.signal()
                }
            }.resume()
            
            _ = semaphore.wait(wallTimeout: .distantFuture)
        }
        
        return users
    }
    
    static func fetchCoreData() -> [User] {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<CDUser>(entityName: "CDUser")
        request.returnsObjectsAsFaults = false
        var users = [User]()
        
        moc.performAndWait {
            let results: [CDUser] = try! request.execute()
            for user in results {
                var friends = [Friend]()
                for friend in user.friends!.allObjects as! [CDFriend] {
                    friends.append(Friend(id: friend.id!, name: friend.name!))
                }
                
                users.append(User(id: user.id!, name: user.name!, age: user.age, company: user.company!, friends: friends))
            }
        }
        return users
    }
    
    static func saveToCoreData(users: [User]) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        moc.performAndWait {
            users.forEach { user in
                let cdUser = CDUser(context: moc)
                cdUser.id = user.id
                cdUser.name = user.name
                cdUser.age = Int16(user.age)
                cdUser.company = user.company
                
                
                user.friends.forEach { friend in
                    let cdFriend = CDFriend(context: moc)
                    
                    cdFriend.id = friend.id
                    cdFriend.name = friend.name
                    cdFriend.user = cdUser
                }
            }
        }
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
}
