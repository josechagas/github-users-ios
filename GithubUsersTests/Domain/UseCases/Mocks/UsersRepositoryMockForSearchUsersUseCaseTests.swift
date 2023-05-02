//
//  UsersRepositoryMockForSearchUsersUseCaseTests.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import Foundation
@testable import GithubUsers

class UsersRepositoryMockforSearchUsersUseCaseTests: UsersRepositoryProtocol {
    
    private(set) var lastSearchParams: LastSearchParams? = nil
    private(set) var successResult: GithubUsers.SearchUsersResult?
    private(set) var error: Error?
    
    init(withError error: Error) {
        self.error = error
        self.successResult = nil
    }
    
    init(withResult result: GithubUsers.SearchUsersResult) {
        self.error = nil
        self.successResult = result
    }
    
    func updateForNextPage(nextPageResult: GithubUsers.SearchUsersResult?, error: Error?) {
        self.successResult = nextPageResult
        self.error = error
    }
    
    func loadUsers() async throws -> [GithubUsers.SmallUserInfo] {
        return []
    }
    
    func searchUsers(by: String, page: Int, perPage: Int, sortBy: GithubUsers.SearchUsersSortBy?, orderBy: GithubUsers.SearchUsersOrderBy) async throws -> GithubUsers.SearchUsersResult {
        lastSearchParams = LastSearchParams(by: by, page: page, perPage: perPage, sortBy: sortBy, orderBy: orderBy)
        
        if let successResult {
            return successResult
        } else if let error {
            throw error
        }
        
        return successResult!
    }
    
    
    struct LastSearchParams {
        let by: String
        let page: Int
        let perPage: Int
        let sortBy: GithubUsers.SearchUsersSortBy?
        let orderBy: GithubUsers.SearchUsersOrderBy
    }

}

