//
//  SearchUsersViewModelProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import Foundation

@MainActor
protocol SearchUsersViewModelProtocol {
    var users: [SmallUserInfo]? {get}
    var executionStatus: ExecutionStatus {get}
    var paginationExecutionStatus: ExecutionStatus {get}

    var userPublisher: Published<[SmallUserInfo]?>.Publisher {get}
    var executionStatusPublisher: Published<ExecutionStatus>.Publisher {get}
    var paginationExecutionStatusPublisher: Published<ExecutionStatus>.Publisher {get}

    func searchUsersBy(search: String) async
    func fetchMoreSearchResults(lastIndex: Int) async
    
    func numberOfItems() -> Int
    func itemAtIndex(index: Int) -> SmallUserInfo?
}
