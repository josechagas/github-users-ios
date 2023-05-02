//
//  SearchUsersUseCase.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 27/04/23.
//

import Foundation

class SearchUsersUseCase: SearchUsersUseCaseProtocol {
    let perPage: Int = 20
    
    private var currentPage: Int = 1
    private var currentSearch: String? = nil
    private var currentSearchTotalCount: Int = 0
    private var currentSearchSortBy: SearchUsersSortBy? = nil
    private var currentSearchOrder: SearchUsersOrderBy = .ascending
    
    private let usersRepository: UsersRepositoryProtocol
    
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
    
    func searchUsers(search: String, sortBy: SearchUsersSortBy?, orderBy: SearchUsersOrderBy) async throws -> [SmallUserInfo] {
        let result = try await usersRepository.searchUsers(by: search, page: 1, perPage: perPage, sortBy: sortBy, orderBy: orderBy)
        updateCurrentSearchData(search: search, totalCount: result.totalCount, sortBy: sortBy, orderBy: orderBy)
        return result.users
    }
    
    func loadMoreForLastSearch() async throws -> [SmallUserInfo] {
        guard containsNextPage(), let search = currentSearch else {
            return []
        }
        
        let newPage: Int = currentPage + 1
        let result = try await usersRepository.searchUsers(by: search, page: newPage, perPage: perPage, sortBy: currentSearchSortBy, orderBy: currentSearchOrder)
        currentPage = newPage
        
        return result.users
    }
    
    private func containsNextPage() -> Bool {
        return currentSearchTotalCount - currentPage*perPage > 0
    }
    
    private func updateCurrentSearchData(search: String, totalCount: Int, sortBy: SearchUsersSortBy?, orderBy: SearchUsersOrderBy) {
        currentPage = 1
        currentSearch = search
        currentSearchTotalCount = totalCount
        currentSearchSortBy = sortBy
        currentSearchOrder = orderBy
    }
}
