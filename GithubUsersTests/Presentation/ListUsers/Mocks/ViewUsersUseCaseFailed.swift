//
//  ViewUsersUseCaseFailed.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation
@testable import GithubUsers

struct ViewUsersUseCaseFailed: ViewUsersUseCaseProtocol {
    var error: Error = ApiRequestError.unknownError
    
    init(){}
    
    init(error: Error) {
        self.error = error
    }
    
    func loadUsers() async throws -> [GithubUsers.SmallUserInfo] {
        throw error
    }
}
