//
//  ListUsersViewModelFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

@MainActor
class ListUsersViewModelFactory {
    class func make() -> any ListUsersViewModelProtocol {
        let useCase = ViewUsersUseCaseFactory.make()
        return ListUsersViewModel(viewUsersUseCase: useCase)
    }
}
