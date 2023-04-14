//
//  ViewUserReposUseCaseFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

class ViewUserReposUseCaseFactory {
    class func make() -> ViewUserReposUseCaseProtocol {
        let repository = ReposRepositoryFactory.make()
        return ViewUserReposUseCase(reposRepository: repository)
    }
}
