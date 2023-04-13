//
//  ViewUsersUseCaseFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

class ViewUsersUseCaseFactory {
    class func make() -> ViewUsersUseCaseProtocol {
        let usersRepository = UsersRepositoryFactory.make()
        return ViewUsersUseCase(usersRepository: usersRepository)
    }
}
