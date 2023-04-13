//
//  UsersApiService.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct UsersApiService: UsersApiServiceProtocol {
    func loadUsers() async throws -> [LoadUsersResponse] {
        let endpoint = ListUsersEndpoint()
        let response: [LoadUsersResponse]? =  try await GithubApiClient.instance().execute(request: endpoint)
        return response ?? []
    }
}
