//
//  ListUserReposViewModelProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

@MainActor
protocol ListUserReposViewModelProtocol {
    var userLogin: String {get}
    var repos: [GithubRepository]? {get}
    var executionStatus: ExecutionStatus {get}
    var reposPublisher: Published<[GithubRepository]?>.Publisher {get}
    var executionStatusPublisher: Published<ExecutionStatus>.Publisher {get}
    
    func loadUserRepos() async
    func numberOfRepos() -> Int
    func repoAtIndex(_ index: Int) -> GithubRepository?
}
