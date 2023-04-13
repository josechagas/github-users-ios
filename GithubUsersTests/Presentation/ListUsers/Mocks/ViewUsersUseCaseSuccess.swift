//
//  ViewUsersUseCaseSuccess.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation
@testable import GithubUsers

struct ViewUsersUseCaseSuccess: ViewUsersUseCaseProtocol {
    var users: [GithubUsers.SmallUserInfo] = [
        GithubUsers.SmallUserInfo(
            id: 1, login: "Test 1", avatarUrl: "https://picsum.photos/200", htmlUrl: "https://url.com.br"
        ),
        GithubUsers.SmallUserInfo(
            id: 2, login: "Test 2", avatarUrl: "https://picsum.photos/200", htmlUrl: "https://url.com.br"
        )
    ]
    
    init(){}
    
    init(users: [GithubUsers.SmallUserInfo]) {
        self.users = users
    }
    
    func loadUsers() async throws -> [GithubUsers.SmallUserInfo] {
        return users
    }
}
