//
//  LoadUserResponse.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct LoadUserResponse: Codable {
    let id : Int
    let name : String?
    let login : String
    let avatarUrl : String?
    let email : String?
    let bio : String?
    let company : String?
    let location : String?
    let followers : Int
    let following : Int
    let publicGists : Int
    let publicRepos : Int
    let blog : String?
    let eventsUrl : String?
    let gravatarId : String?
    let hireable : Bool?
    let ownedPrivateRepos : Int?
    let receivedEventsUrl : String?
    let siteAdmin : Bool?
    let type : String?
    let createdAt : String?
    let updatedAt : String?
    let url : String?
    let htmlUrl : String
    let subscriptionsUrl : String?
    let starredUrl : String?
    let reposUrl : String?
    let followersUrl : String?
    let followingUrl : String?
    let gistsUrl : String?
    let organizationsUrl : String?


    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case bio
        case blog
        case company
        case createdAt = "created_at"
        case email
        case eventsUrl = "events_url"
        case followers
        case followersUrl = "followers_url"
        case following
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case gravatarId = "gravatar_id"
        case hireable
        case htmlUrl = "html_url"
        case id
        case location
        case login
        case name
        case organizationsUrl = "organizations_url"
        case ownedPrivateRepos = "owned_private_repos"
        case publicGists = "public_gists"
        case publicRepos = "public_repos"
        case receivedEventsUrl = "received_events_url"
        case reposUrl = "repos_url"
        case siteAdmin = "site_admin"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case type
        case updatedAt = "updated_at"
        case url
    }
}
