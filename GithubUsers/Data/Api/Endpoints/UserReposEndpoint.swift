//
//  UserReposEndpoint.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import Foundation

struct UserReposEndpoint: ApiRequest {
    var endpoint: String
    var method: ApiRequestMethod = .get
    var body: Codable? = nil
    var headers: ApiRequestHeaders = [:]
    var queries: ApiRequestQueries = [:]
    
    init(userLogin: String) {
        endpoint = "users/"+userLogin+"/repos"
    }
}
