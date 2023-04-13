//
//  UsersRepository.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct UsersRepository: UsersRepositoryProtocol {
    
    private let usersService: UsersApiServiceProtocol
        
    init(usersService: UsersApiServiceProtocol) {
        self.usersService = usersService
    }
    
    func loadUsers() async throws -> [SmallUserInfo] {
        let result = try await usersService.loadUsers()
        return result.map({
            SmallUserInfo(response: $0)
        })
    }
}

fileprivate extension SmallUserInfo {
    init(response: LoadUsersResponse) {
        self.init(id: response.id, login: response.login, avatarUrl: response.avatarUrl, htmlUrl: response.htmlUrl)
    }
}
