//
//  User.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let name: String
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "profile_picture_url"
    }
}

struct Page: Decodable {
    let users: [User]
}

struct PaginatedResponse: Decodable {
    let pages: [Page]
}
