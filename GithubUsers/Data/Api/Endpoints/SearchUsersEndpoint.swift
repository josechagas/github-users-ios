//
//  SearchUsersEndpoint.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 27/04/23.
//

import Foundation

//https://api.github.com/search/users?q={query}{&page,per_page,sort,order}
struct SearchUsersEndpoint: ApiRequest {
    static let perPageMaxValue = 100

    
    let endpoint: String = "search/users"
    let method: ApiRequestMethod = .get
    let body: Codable? = nil
    let headers: ApiRequestHeaders = [:]
    let queries: ApiRequestQueries
    
    
    init(by: String, page: Int=1, perPage: Int=perPageMaxValue, sortBy: SortBy?=nil, order: Order = Order.desc) throws {
        guard !by.replacingOccurrences(of: " ", with: "").isEmpty else {
            throw SearchUsersEndpointError.searchCanNotBeBlank
        }
        
        guard page > 0 else {
            throw SearchUsersEndpointError.pageLessThanOne
        }
        
        guard perPage > 0 else {
            throw SearchUsersEndpointError.perPageLessThanOne
        }
        
        guard perPage <= SearchUsersEndpoint.perPageMaxValue else {
            throw SearchUsersEndpointError.perPageBiggerThanMax
        }
        
        queries = [
            "q": by,
            "page": String(describing: page),
            "per_page": String(describing: perPage),
            "sort": sortBy?.rawValue,
            "order": order.rawValue
        ]
    }
}

enum SearchUsersEndpointError: Error {
    case pageLessThanOne
    case perPageLessThanOne
    case perPageBiggerThanMax
    case searchCanNotBeBlank
}

