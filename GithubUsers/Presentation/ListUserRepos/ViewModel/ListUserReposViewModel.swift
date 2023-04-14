//
//  ListUserReposViewModel.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

class ListUserReposViewModel: ListUserReposViewModelProtocol {
    private(set) var userLogin: String
    
    @Published private(set) var repos: [GithubRepository]? = nil
    @Published private(set) var executionStatus: ExecutionStatus = .none
    
    var reposPublisher: Published<[GithubRepository]?>.Publisher {$repos}
    var executionStatusPublisher: Published<ExecutionStatus>.Publisher {$executionStatus}
    
    private let viewUserReposUseCase: ViewUserReposUseCaseProtocol
    
    init(userLogin: String, viewUserReposUseCase: ViewUserReposUseCaseProtocol) {
        self.userLogin = userLogin
        self.viewUserReposUseCase = viewUserReposUseCase
    }
    
    func loadUserRepos() async {
        executionStatus = .inProgress
        do {
            repos = try await viewUserReposUseCase.loadUserRepos(userLogin: userLogin)
            executionStatus = (repos?.isEmpty ?? true) ? .noData : .success
        } catch {
            executionStatus = .failed(error: error)
        }
    }
    
    func numberOfRepos() -> Int {
        return repos?.count ?? 0
    }
    
    func repoAtIndex(_ index: Int) -> GithubRepository? {
        guard let repos = repos, index < repos.count, index >= 0 else {
            return nil
        }
        return repos[index]
    }
    
    
}
