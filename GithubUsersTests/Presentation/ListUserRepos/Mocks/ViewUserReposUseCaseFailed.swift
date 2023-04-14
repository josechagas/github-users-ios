//
//  ViewUserReposUseCaseFailed.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

@testable import GithubUsers

struct ViewUserReposUseCaseFailed: ViewUserReposUseCaseProtocol {
    
    var error: Error = ApiRequestError.unknownError
    
    init(){}
    
    init(error: Error) {
        self.error = error
    }
    
    
    func loadUserRepos(userLogin: String) async throws -> [GithubUsers.GithubRepository] {
        throw error
    }
}
