//
//  UserRepositoryFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation


class UserRepositoryFactory {
    class func make() -> UserRepositoryProtocol {
        let userService = UserApiService()
        return UserRepository(userService: userService)
    }
}
