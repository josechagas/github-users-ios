//
//  ApiRequestResponse.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct ApiRequestResponse<Content: Codable>: Codable {
    let error: ErrorData?
    let data: Content?
}

struct ErrorData: Codable {
    let message: String
    let code: String
}
