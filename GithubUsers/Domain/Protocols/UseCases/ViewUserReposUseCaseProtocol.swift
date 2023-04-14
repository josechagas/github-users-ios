//
//  ViewUserReposUseCaseProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

protocol ViewUserReposUseCaseProtocol {
    func loadUserRepos(userLogin: String) async throws -> [GithubRepository]
}
