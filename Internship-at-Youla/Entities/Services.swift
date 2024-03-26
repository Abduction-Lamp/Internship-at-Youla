//
//  Services.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import Foundation

struct Services: Codable {
    
    let name:        String
    let description: String
    let link:        String
    let iconURL:     String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case link
        case iconURL = "icon_url"
    }
}

