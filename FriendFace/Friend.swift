//
//  Friend.swift
//  FriendFace
//
//  Created by Jules Lee on 1/10/20.
//  Copyright © 2020 Jules Lee. All rights reserved.
//

import Foundation

struct Friend: Codable, Identifiable {
    var id: UUID
    var name: String
}
