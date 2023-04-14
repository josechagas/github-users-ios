//
//  User.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct User {
    var id: Int
    var login: String
    var name: String?
    var company: String?
    var email: String?
    var bio: String?
    var numberOfPublicRepos: Int
    var numberOfPublicGists: Int
    var followers: Int
    var following: Int
    var avatarUrl: String?
    var htmlUrl: String
}
