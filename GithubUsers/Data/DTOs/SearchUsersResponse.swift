//
//  SearchUsersResponse.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 27/04/23.
//

import Foundation

struct SearchUsersResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [LoadUsersResponse]
    
    enum CodingKeys:String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
