//
//  UserDetailsUseCase.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

class UserDetailsUseCase: UserDetailsUseCaseProtocol {
    
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func loadUserDetails(login: String) async throws -> User? {
        return try await userRepository.loadUserDetails(login: login)
    }
}
