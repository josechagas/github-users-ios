//
//  SearchUsersUseCaseMock.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 04/05/23.
//

import Foundation
@testable import GithubUsers

struct SearchUsersUseCaseMock: SearchUsersUseCaseProtocol {
    
    let searchUsersResult: Result<[GithubUsers.SmallUserInfo], Error>
    let loadMoreForLastSearchResult: Result<[GithubUsers.SmallUserInfo], Error>
    
    func searchUsers(search: String, sortBy: GithubUsers.SearchUsersSortBy?, orderBy: GithubUsers.SearchUsersOrderBy) async throws -> [GithubUsers.SmallUserInfo] {
        switch searchUsersResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func loadMoreForLastSearch() async throws -> [GithubUsers.SmallUserInfo] {
        switch searchUsersResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    
}
