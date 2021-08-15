//
//  Photos.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/14/21.
//

import Foundation

// MARK: - Photos
struct SearchResults: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [PhotoInfo]
}

// MARK: - Photo
struct PhotoInfo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
