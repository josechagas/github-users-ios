//
//  UserDetailsUseCaseFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

class UserDetailsUseCaseFactory {
    class func make() -> UserDetailsUseCaseProtocol {
        let userRepository = UserRepositoryFactory.make()
        return UserDetailsUseCase(userRepository: userRepository)
    }
}
