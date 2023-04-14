//
//  ReposApiServiceProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

protocol ReposApiServiceProtocol {
    func loadReposOfUser(userLogin: String) async throws -> [LoadUserReposResponse]?
}
