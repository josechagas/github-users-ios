//
//  UsersRepositoryProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

protocol UsersRepositoryProtocol {
    func loadUsers() async throws -> [SmallUserInfo]
    func searchUsers(by: String,
                     page: Int,
                     perPage: Int,
                     sortBy: SearchUsersSortBy?,
                     orderBy: SearchUsersOrderBy
    ) async throws -> SearchUsersResult
}
