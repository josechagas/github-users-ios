//
//  ViewUserReposUseCaseSuccess.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation
@testable import GithubUsers

struct ViewUserReposUseCaseSuccess: ViewUserReposUseCaseProtocol {
    
    var repos: [GithubUsers.GithubRepository] = [
        GithubRepository(id: 100, name: "Some name", fullName: "full/name", htmlUrl: "https://github.com/", watchersCount: 999, forks: 10, isPrivate: false, openIssues: 100, createdAt: Date(), owner: SmallUserInfo(id: 9, login: "some_owner", htmlUrl: "https://github.com/some_owner/")),
        GithubRepository(id: 200, name: "Some name", fullName: "full/name", htmlUrl: "https://github.com/", watchersCount: 999, forks: 10, isPrivate: false, openIssues: 100, createdAt: Date(), owner: SmallUserInfo(id: 9, login: "some_owner", htmlUrl: "https://github.com/some_owner/"))

    ]
    
    init(){}
    
    init(repos: [GithubUsers.GithubRepository]) {
        self.repos = repos
    }
    
    
    func loadUserRepos(userLogin: String) async throws -> [GithubUsers.GithubRepository] {
        return repos
    }
}
