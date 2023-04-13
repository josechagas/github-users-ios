//
//  LoadUsersResponse.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct LoadUsersResponse: Codable {
    var login: String
    var id: Int
    var nodeId: String
    var avatarUrl: String?
    var gravatarId: String?
    var url: String
    var htmlUrl: String
    var type: String
    var siteAdmin: Bool
    
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

/*
 {
   "login": "mojombo",
   "id": 1,
   "node_id": "MDQ6VXNlcjE=",
   "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
   "gravatar_id": "",
   "url": "https://api.github.com/users/mojombo",
   "html_url": "https://github.com/mojombo",
   "followers_url": "https://api.github.com/users/mojombo/followers",
   "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
   "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
   "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
   "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
   "organizations_url": "https://api.github.com/users/mojombo/orgs",
   "repos_url": "https://api.github.com/users/mojombo/repos",
   "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
   "received_events_url": "https://api.github.com/users/mojombo/received_events",
   "type": "User",
   "site_admin": false
 }
 */
