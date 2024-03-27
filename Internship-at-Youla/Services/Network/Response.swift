//
//  Response.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import Foundation

struct ServicesResponse: Codable {
    let body: BodyResponse
    let status: Int
    
    private enum CodingKeys: String, CodingKey {
        case body
        case status
    }
}

struct BodyResponse: Codable {
    let services: [Services]
    
    private enum CodingKeys: String, CodingKey {
        case services
    }
}
