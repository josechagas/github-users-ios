//
//  ApiClientBuilder.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

struct ApiClientBuilder: Client {
    fileprivate(set) var baseUrl: String
    fileprivate(set) var urlSession: URLSession = URLSession.shared
    fileprivate(set) var headers: ApiRequestHeaders = [:]
    fileprivate(set) var queries: ApiRequestQueries = [:]
    fileprivate(set) var errorBodyInterceptor: ErrorBodyInterceptor

    init(baseUrl: String) {
        self.baseUrl = baseUrl
        errorBodyInterceptor = { data, response in
            return data
        }
    }
    
    func addErrorBodyInterceptor(_ clousure:@escaping ErrorBodyInterceptor) -> Self {
        var newSelf = self
        newSelf.errorBodyInterceptor = errorBodyInterceptor
        return newSelf
    }
    
    func setUrlSession(_ session: URLSession) -> Self {
        var newSelf = self
        newSelf.urlSession = session
        return newSelf
    }

    func addHeaders(_ headers: ApiRequestHeaders) -> Self {
        var newSelf = self
        newSelf.headers.merge(headers) { defaultValue, newValue in
            return newValue
        }
        return newSelf
    }
    
    func addQueries(_ queries: ApiRequestQueries) -> Self {
        var newSelf = self
        newSelf.queries.merge(queries) { defaultValue, newValue in
            return newValue
        }
        return newSelf
    }
    
    func withCustomAuth(header: String, value: String) -> Self {
        var newSelf = self
        newSelf.headers[header] = value
        return newSelf
    }
    
    func withAuth(token: String) -> Self {
        var newSelf = self
        newSelf.headers[ApiRequestHeaderFields.authorization.rawValue] = token
        return newSelf
    }

    func build()-> ApiClient {
        return ApiClient(baseUrl: baseUrl,
                         urlSession: urlSession,
                         headers: headers,
                         queries: queries,
                         errorBodyInterceptor: errorBodyInterceptor
        )
    }
}
