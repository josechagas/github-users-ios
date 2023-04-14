//
//  ReposRepositoryFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation


class ReposRepositoryFactory {
    class func make() -> ReposRepositoryProtocol {
        return ReposRepository(reposService: ReposApiService())
    }
}
