//
//  ListUsersViewModelProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

@MainActor
protocol ListUsersViewModelProtocol {
    var users: Published<[SmallUserInfo]?>.Publisher {get}
    var executionStatus: Published<ExecutionStatus>.Publisher {get}
    
    func loadUsers() async
    
    func numberOfUsers()-> Int
    func userAtIndex(_ index: Int) -> SmallUserInfo?
}
