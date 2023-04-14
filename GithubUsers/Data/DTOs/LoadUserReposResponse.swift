//
//  LoadUserReposResponse.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct LoadUserReposResponse: Codable {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: String?
    let watchersCount: Int
    let forks: Int
    let isPrivate: Bool
    let openIssues: Int
    let createdAt: Date
    let owner: LoadUserReposResponse.Owner
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case watchersCount = "watchers_count"
        case forks
        case isPrivate = "private"
        case openIssues = "open_issues"
        case createdAt = "created_at"
        case owner
    }
}

extension LoadUserReposResponse {
    struct Owner: Codable {
        let id: Int
        let login: String
        let avatarUrl: String?
        let htmlUrl: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case login
            case avatarUrl = "avatar_url"
            case htmlUrl = "html_url"
        }
    }
}
