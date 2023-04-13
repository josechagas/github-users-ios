//
//  ApiRequest.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

typealias ApiRequestHeaders = [String: String?]
typealias ApiRequestQueries = [String: String?]

protocol ApiRequest {
    var endpoint: String {get}
    var method: ApiRequestMethod {get}
    var body: Codable? {get}
    var headers: ApiRequestHeaders {get}
    var queries: ApiRequestQueries {get}
}

enum ApiRequestMethod: String {
    case get = "GET"
    case delete = "DELETE"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
}

enum ApiRequestHeaderFields: String {
    case authorization = "authorization"
}

enum ApiRequestError: Error {
    case invalidUrlPath(path: String)
    case requestFailed(statusCode: Int, errorBody: Any?)
    case unknownError
}
