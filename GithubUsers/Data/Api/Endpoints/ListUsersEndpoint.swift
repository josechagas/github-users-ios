//
//  ListUsersEndpoint.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct ListUsersEndpoint: ApiRequest {
    var endpoint: String = "users"
    var method: ApiRequestMethod = ApiRequestMethod.get
    var body: Codable? = nil
    var headers: ApiRequestHeaders = [:]
    var queries: ApiRequestQueries = [:]
    
    init(){}
}
