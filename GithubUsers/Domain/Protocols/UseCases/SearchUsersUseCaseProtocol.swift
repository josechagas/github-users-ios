//
//  SearchUsersUseCaseProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 27/04/23.
//

import Foundation

protocol SearchUsersUseCaseProtocol {
    func searchUsers(search: String,
                     sortBy: SearchUsersSortBy?,
                     orderBy: SearchUsersOrderBy
    ) async throws -> [SmallUserInfo]
    func loadMoreForLastSearch() async throws -> [SmallUserInfo]
}
