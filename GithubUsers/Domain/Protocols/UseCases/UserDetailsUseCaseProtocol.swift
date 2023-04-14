//
//  UserDetailsUseCaseProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

protocol UserDetailsUseCaseProtocol {
    func loadUserDetails(login: String) async throws -> User?
}
