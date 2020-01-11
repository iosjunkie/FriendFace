//
//  ContentView.swift
//  FriendFace
//
//  Created by Jules Lee on 1/10/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var users = User.fetch()
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: FriendsList(friends: user.friends)) {
                    Text("\(user.name) \(user.age)")
                }
            }
            .navigationBarTitle("Users")
            .navigationBarItems(leading: Button("DeleteAll") {
                    self.deleteAll()
                }, trailing: Button("Fetch") {
                    self.fetch()
                }
            )
        }
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()

        fetchRequest.entity = CDUser.entity()
        fetchRequest.includesPropertyValues = false

        do
        {
            let results = try moc.fetch(fetchRequest)
            for managedObject in results
            {
                if let object = managedObject as? NSManagedObject {
                    moc.delete(object)
                }
            }
        } catch let error as NSError {
            print("Delete All Error : \(error) ")
        }
    }
    
    func fetch() {
        users = User.fetch()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
