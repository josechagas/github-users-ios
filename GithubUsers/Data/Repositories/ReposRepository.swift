//
//  ReposRepository.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct ReposRepository: ReposRepositoryProtocol {
    
    private let reposService: ReposApiServiceProtocol
    
    init(reposService: ReposApiServiceProtocol) {
        self.reposService = reposService
    }
    
    func loadReposOfUser(userLogin: String) async throws -> [GithubRepository] {
        let result = try await reposService.loadReposOfUser(userLogin: userLogin)
        return result?.map({ response in
            let owner = SmallUserInfo(
                id: response.owner.id,
                login: response.owner.login,
                avatarUrl: response.owner.avatarUrl,
                htmlUrl: response.owner.htmlUrl
            )
            
            return GithubRepository(
                id: response.id,
                name: response.name,
                fullName: response.fullName,
                htmlUrl: response.htmlUrl,
                watchersCount: response.watchersCount,
                forks: response.forks,
                isPrivate: response.isPrivate,
                openIssues: response.openIssues,
                createdAt: response.createdAt,
                owner: owner
            )
        }) ?? []
    }
}
