//
//  SearchUsersViewModel.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import Foundation


class SearchUsersViewModel: SearchUsersViewModelProtocol {
    @Published private(set) var users: [SmallUserInfo]? = nil
    
    @Published private(set) var executionStatus: ExecutionStatus = .none
    @Published private(set) var paginationExecutionStatus: ExecutionStatus = .none

    
    var userPublisher: Published<[SmallUserInfo]?>.Publisher {$users}
    
    var executionStatusPublisher: Published<ExecutionStatus>.Publisher {$executionStatus}
    var paginationExecutionStatusPublisher: Published<ExecutionStatus>.Publisher {$paginationExecutionStatus}

    private let searchUsersUseCase: SearchUsersUseCaseProtocol
    
    init(usecase: SearchUsersUseCaseProtocol) {
        searchUsersUseCase = usecase
    }
    
    func searchUsersBy(search: String) async {
        executionStatus = .inProgress
        do {
            let result = try await searchUsersUseCase.searchUsers(search: search, sortBy: nil, orderBy: .ascending)
            users = result
            executionStatus = result.isEmpty ? .noData : .success
        } catch {
            executionStatus = .failed(error: error)
        }
    }
    
    func fetchMoreSearchResults(lastIndex: Int) async {
        if itsTimeToLoadMoreItems(lastIndex: lastIndex) {
            await loadMoreForCurrentSearch()
        }
    }
    
    private func itsTimeToLoadMoreItems(lastIndex: Int)-> Bool {
        let itemsCount = numberOfItems()
        return itemsCount > 0 && lastIndex > 0 && lastIndex >= itemsCount - 3
    }
    
    private func loadMoreForCurrentSearch() async {
        if case .inProgress = paginationExecutionStatus {
            return
        }
        
        paginationExecutionStatus = .inProgress
        do {
            let result = try await searchUsersUseCase.loadMoreForLastSearch()
            users?.append(contentsOf: result)
            paginationExecutionStatus = .success
        } catch {
            paginationExecutionStatus = .failed(error: error)
        }
    }
    
    func numberOfItems() -> Int {
        return users?.count ?? 0
    }
    
    func itemAtIndex(index: Int) -> SmallUserInfo? {
        guard let users, index >= 0, index < users.count else {
            return nil
        }
        return users[index]
    }

}
