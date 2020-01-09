//
//  ContentView.swift
//  FriendFace
//
//  Created by Jules Lee on 1/10/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var users = User.fetch()
    var body: some View {
        NavigationView {
            List(users) { user in
                Text("\(user.name) \(user.age)")
            }
            .navigationBarTitle("Users and Friends")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
