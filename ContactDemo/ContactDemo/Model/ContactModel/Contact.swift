//
//  Contact.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

public class Contact: Codable {
    var favorite: Bool?
    var firstName: String?
    var lastName: String?
    var profilePicUrl: String?
    var detailUrl: String?
    var profileId: Int?
    var mobileNumber: String?
    var emailAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case favorite
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicUrl = "profile_pic"
        case detailUrl = "url"
        case profileId = "id"
        case mobileNumber = "phone_number"
        case emailAddress = "email"
    }
}
