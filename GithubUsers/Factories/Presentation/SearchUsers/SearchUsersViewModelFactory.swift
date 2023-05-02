//
//  SearchUsersViewModelFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import Foundation

@MainActor
class SearchUsersViewModelFactory {
    class func make()-> SearchUsersViewModelProtocol {
        let usecase = SearchUsersUseCaseFactory.make()
        return SearchUsersViewModel(usecase: usecase)
    }
}
