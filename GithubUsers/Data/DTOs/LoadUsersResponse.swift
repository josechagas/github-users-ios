//
//  LoadUsersResponse.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct LoadUsersResponse: Codable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String?
    let gravatarId: String?
    let url: String
    let htmlUrl: String
    let type: String
    let siteAdmin: Bool
    
    enum CodingKeys:String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case type
        case siteAdmin = "site_admin"
    }
}
