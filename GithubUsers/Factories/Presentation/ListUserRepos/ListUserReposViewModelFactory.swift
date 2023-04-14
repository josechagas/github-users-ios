//
//  ListUserReposViewModelFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

@MainActor
class ListUserReposViewModelFactory {
    class func make(userLogin: String) -> ListUserReposViewModelProtocol {
        let useCase = ViewUserReposUseCaseFactory.make()
        return ListUserReposViewModel(userLogin: userLogin, viewUserReposUseCase: useCase)
    }
}
