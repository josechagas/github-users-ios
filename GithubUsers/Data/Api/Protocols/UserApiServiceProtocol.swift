//
//  UserApiServiceProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation


protocol UserApiServiceProtocol {
    func loadUser(login: String) async throws -> LoadUserResponse
}
