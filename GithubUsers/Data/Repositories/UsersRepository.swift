//
//  UsersRepository.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct UsersRepository: UsersRepositoryProtocol {
    private let usersService: UsersApiServiceProtocol
        
    init(usersService: UsersApiServiceProtocol) {
        self.usersService = usersService
    }
    
    func loadUsers() async throws -> [SmallUserInfo] {
        let result = try await usersService.loadUsers()
        return result.map({
            SmallUserInfo(response: $0)
        })
    }
    
    func searchUsers(by: String, page: Int, perPage: Int, sortBy: SearchUsersSortBy?, orderBy: SearchUsersOrderBy) async throws -> SearchUsersResult {
        let result = try await usersService.searchUsers(
            search: by,
            page: page,
            perPage: perPage,
            sort: SortBy(from: sortBy),
            order: Order(from: orderBy)
        )
        
        return SearchUsersResult(
            totalCount: result.totalCount, users: result.items.map({
                SmallUserInfo(response: $0)
            }))
    }
    

}

fileprivate extension SmallUserInfo {
    init(response: LoadUsersResponse) {
        self.init(id: response.id, login: response.login, avatarUrl: response.avatarUrl, htmlUrl: response.htmlUrl)
    }
}

fileprivate extension SortBy {
    init?(from: SearchUsersSortBy?) {
        guard let from else {
            return nil
        }
        switch from {
        case .followers:
            self = .followers
        case .repositories:
            self = .repositories
        case .joined:
            self = .joined
        }
    }
}

fileprivate extension Order {
    init(from: SearchUsersOrderBy) {
        switch from {
        case .ascending:
            self = .asc
        case .descending:
            self = .desc
        }
    }
}
