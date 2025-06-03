//
//  Story.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//

import Foundation

struct Story: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let imageURL: String
    var isSeen: Bool
    var isLiked: Bool
}
