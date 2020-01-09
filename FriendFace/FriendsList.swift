//
//  FriendsList.swift
//  FriendFace
//
//  Created by Jules Lee on 1/10/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import SwiftUI

struct FriendsList: View {
    let friends: [Friend]
    var body: some View {
        VStack {
            List(friends) { friend in
                Text(friend.name)
            }
        }
    .navigationBarTitle("Friends")
    }
}

struct FriendsList_Previews: PreviewProvider {
    let friends = User.fetch().first?.friends
    static var previews: some View {
        FriendsList(friends: [Friend]())
    }
}
