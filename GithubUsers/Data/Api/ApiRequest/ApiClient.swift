//
//  ApiClient.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

struct ApiClient: Client {
    fileprivate(set) var baseUrl: String
    fileprivate(set) var urlSession: URLSession
    fileprivate(set) var headers: ApiRequestHeaders
    fileprivate(set) var queries: ApiRequestQueries
    fileprivate(set) var errorBodyInterceptor: ErrorBodyInterceptor
    
    init(baseUrl: String,
                     urlSession: URLSession,
                     headers: ApiRequestHeaders,
                     queries: ApiRequestQueries,
                     errorBodyInterceptor: @escaping ErrorBodyInterceptor
    ) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
        self.headers = headers
        self.queries = queries
        self.errorBodyInterceptor = errorBodyInterceptor
    }
}

protocol Client {
    var baseUrl: String {get}
    var urlSession: URLSession {get}
    var headers: ApiRequestHeaders {get}
    var queries: ApiRequestQueries {get}
    var errorBodyInterceptor: ErrorBodyInterceptor {get}
}

typealias ErrorBodyInterceptor = (Data?, HTTPURLResponse?)->Any?
