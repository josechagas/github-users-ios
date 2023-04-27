//
//  UserRepository.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct UserRepository: UserRepositoryProtocol {
    
    private let userService: UserApiServiceProtocol
    
    init(userService: UserApiServiceProtocol) {
        self.userService = userService
    }
    
    func loadUserDetails(login: String) async throws -> User? {
        let response = try await userService.loadUser(login: login)
        
        return User(
            id: response.id,
            login: response.login,
            name: response.name,
            company: response.company,
            email: response.email,
            bio: response.bio,
            numberOfPublicRepos: response.publicRepos,
            numberOfPublicGists: response.publicGists,
            followers: response.followers,
            following: response.following,
            avatarUrl: response.avatarUrl,
            htmlUrl: response.htmlUrl
        )
    }
}
