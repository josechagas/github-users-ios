//
//  UserDetailsUseCaseSuccess.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation
@testable import GithubUsers


struct UserDetailsUseCaseSuccess: UserDetailsUseCaseProtocol {
    
    let user: User?
    
    init(noData: Bool) {
        user = noData ? nil :
        User(id: 1,
             login: "some_user",
             numberOfPublicRepos: 100,
             numberOfPublicGists: 0,
             followers: 99999,
             following: 1,
             htmlUrl: "https://some.user.url/"
        )
    }
    
    
    func loadUserDetails(login: String) async throws -> GithubUsers.User? {
        return user
    }
}
