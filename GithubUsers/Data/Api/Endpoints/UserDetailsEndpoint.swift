//
//  UserDetailsEndpoint.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct UserDetailsEndpoint: ApiRequest {
    let endpoint: String
    let method: ApiRequestMethod = .get
    let body: Codable? = nil
    let headers: ApiRequestHeaders = [:]
    let queries: ApiRequestQueries = [:]
    
    init(login: String) {
        endpoint = "users/"+login
    }
}
