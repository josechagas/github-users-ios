//
//  ViewUsersUseCase.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

class ViewUsersUseCase: ViewUsersUseCaseProtocol {
    
    private let usersRepository: UsersRepositoryProtocol
    
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
    
    func loadUsers() async throws -> [SmallUserInfo] {
        return try await usersRepository.loadUsers()
    }
}
