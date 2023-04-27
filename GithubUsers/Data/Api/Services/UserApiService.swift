//
//  UserApiService.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct UserApiService: UserApiServiceProtocol {
    func loadUser(login: String) async throws -> LoadUserResponse {
        let endpoint = UserDetailsEndpoint(login: login)
        return try await GithubApiClient.instance().execute(request: endpoint)
    }
}
