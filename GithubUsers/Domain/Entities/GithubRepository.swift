//
//  GithubRepository.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct GithubRepository {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: String?
    let watchersCount: Int
    let forks: Int
    let isPrivate: Bool
    let openIssues: Int
    let createdAt: Date
    let owner: SmallUserInfo
}
