//
//  Contact.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

//struct ContactResponse {
//    let contactList
//}

class Contact: Codable {
    var favorite: Bool?
    var firstName: String?
    var lastName: String?
    var profilePicUrl: String?
    var detailUrl: String?
    var profileId: Int?
    
    enum ContactCodingKeys: String, CodingKey {
        case favorite
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicUrl = "profile_pic"
        case detailUrl = "url"
        case profileId = "id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContactCodingKeys.self)
        favorite = try container.decode(Bool.self, forKey: .favorite)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        profilePicUrl = try container.decode(String.self, forKey: .profilePicUrl)
        detailUrl = try container.decode(String.self, forKey: .detailUrl)
        profileId = try container.decode(Int.self, forKey: .profileId)
    }
}
