//
//  SearchUsersUseCaseFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 27/04/23.
//

import Foundation

class SearchUsersUseCaseFactory {
    class func make() -> SearchUsersUseCaseProtocol {
        let repository = UsersRepositoryFactory.make()
        return SearchUsersUseCase(usersRepository: repository)
    }
}
