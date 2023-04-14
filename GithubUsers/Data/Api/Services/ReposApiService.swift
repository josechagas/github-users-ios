//
//  ReposApiService.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct ReposApiService: ReposApiServiceProtocol {
    func loadReposOfUser(userLogin: String) async throws -> [LoadUserReposResponse]? {
        let endpoint = UserReposEndpoint(userLogin: userLogin)
        return try await GithubApiClient.instance().execute(request: endpoint)
    }
}
