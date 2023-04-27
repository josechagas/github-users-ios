//
//  UsersApiServiceProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

protocol UsersApiServiceProtocol {
    func loadUsers() async throws -> [LoadUsersResponse]
    func searchUsers(search: String,
                     page: Int,
                     perPage: Int,
                     sort: SortBy?,
                     order: Order
    ) async throws -> SearchUsersResponse
}
