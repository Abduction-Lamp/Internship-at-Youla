//
//  Errors.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import Foundation

struct NetworkErrors: Error {
    let url: String?
    let message: String
    let error: Error?
    
    init(_ url: String? = nil, _ message: String = "", _ error: Error? = nil) {
        self.url = url
        self.message = message
        self.error = error
    }
}
