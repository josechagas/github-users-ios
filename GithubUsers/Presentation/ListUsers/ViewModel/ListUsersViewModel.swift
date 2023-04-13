//
//  ListUsersViewModel.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation


class ListUsersViewModel: ListUsersViewModelProtocol {
    @Published private var _users: [SmallUserInfo]? = nil
    @Published private var _executionStatus: ExecutionStatus = .none
    
    var users: Published<[SmallUserInfo]?>.Publisher {$_users}
    var executionStatus: Published<ExecutionStatus>.Publisher {$_executionStatus}

    private let viewUsersUseCase: ViewUsersUseCaseProtocol
    
    init(viewUsersUseCase: ViewUsersUseCaseProtocol) {
        self.viewUsersUseCase = viewUsersUseCase
    }
    
    func loadUsers() async {
        _executionStatus = .inProgress
        do {
            _users = try await viewUsersUseCase.loadUsers()
            _executionStatus = .success
        } catch {
            _executionStatus = .failed(error: error)
        }
    }
    
    func numberOfUsers() -> Int {
        return _users?.count ?? 0
    }
    
    func userAtIndex(_ index: Int) -> SmallUserInfo? {
        guard let users = _users, users.count > index else {
            return nil
        }
        return users[index]
    }
}
