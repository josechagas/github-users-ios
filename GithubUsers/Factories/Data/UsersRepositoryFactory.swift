//
//  ViewUsersRepositoryFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

class UsersRepositoryFactory {
    class func make()-> UsersRepositoryProtocol {
        return UsersRepository(usersService: UsersApiService())
    }
}
