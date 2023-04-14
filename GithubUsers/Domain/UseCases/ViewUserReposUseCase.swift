//
//  ViewUserReposUseCase.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation


struct ViewUserReposUseCase: ViewUserReposUseCaseProtocol {
    
    private let reposRepository: ReposRepositoryProtocol
    
    init(reposRepository: ReposRepositoryProtocol) {
        self.reposRepository = reposRepository
    }
    
    func loadUserRepos(userLogin: String) async throws -> [GithubRepository] {
        return try await reposRepository.loadReposOfUser(userLogin: userLogin)
    }
}
