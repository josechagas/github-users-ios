//
//  UserDetailsUseCaseFailed.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation
@testable import GithubUsers

struct UserDetailsUseCaseFailed: UserDetailsUseCaseProtocol {
    var error: Error

    init(error: Error = ApiRequestError.unknownError) {
        self.error = error
    }
    
    func loadUserDetails(login: String) async throws -> GithubUsers.User? {
        throw error
    }
}
