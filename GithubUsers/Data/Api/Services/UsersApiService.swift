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
        let response: [LoadUsersResponse] =  try await GithubApiClient.instance().execute(request: endpoint)
        return response
    }
    
    func searchUsers(search: String, page: Int, perPage: Int, sort: SortBy?, order: Order) async throws -> SearchUsersResponse {
        let endpoint = try SearchUsersEndpoint(
            by: search, page: page, perPage: perPage, sortBy: sort, order: order
        )
        let response: SearchUsersResponse = try await GithubApiClient.instance().execute(request: endpoint)
        return response
    }
}
