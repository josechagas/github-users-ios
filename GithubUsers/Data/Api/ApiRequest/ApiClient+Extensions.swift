//
//  ApiClient+Extensions.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

extension ApiClient {
    func execute<Content: Codable>(request: ApiRequest) async throws -> Content? {
        let urlRequest = try makeURLRequest(request)
        let (data, response) = try await urlSession.data(for: urlRequest)

        try validateURLResponse(body: data, response: response as? HTTPURLResponse)
        let responseBody: Content? = try JSONDecoder().decode(Content.self, from: data)

        return responseBody
    }
    
    private func makeURLRequest(_ request: ApiRequest) throws -> URLRequest {
        let apiClientQueryItems = self.queries.map({
            let value = $0.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return URLQueryItem(name: $0.key, value: value)
        })
        
        let queryItems = request.queries.map({URLQueryItem(name: $0.key, value: $0.value)})
        let endpoint = request.endpoint
        let method = request.method.rawValue
        let headers = request.headers
        let body = request.body
        
        guard let baseURL = URL(string: baseUrl),
              let encodedUrl = endpoint.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed.union(.urlQueryAllowed)),
              var url = URL(string: encodedUrl,relativeTo: baseURL),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw ApiRequestError.invalidUrlPath(path: endpoint)
        }
        
        
        urlComponents.queryItems = apiClientQueryItems + queryItems
        
        guard let url = urlComponents.url else {
            throw ApiRequestError.invalidUrlPath(path: endpoint)
        }
        
        var request = URLRequest(
            url: url
        )
        
        request.httpMethod = method
        
        self.headers.forEach { tuple in
            request.setValue(tuple.value, forHTTPHeaderField: tuple.key)
        }
        headers.forEach { tuple in
            request.setValue(tuple.value, forHTTPHeaderField: tuple.key)
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return request
    }
    
    private func validateURLResponse(body: Data?, response: HTTPURLResponse?) throws {
        guard let statusCode = response?.statusCode else {
            throw ApiRequestError.unknownError
        }

        let successfulResponse = isSuccessStatusCode(statusCode: statusCode)
        if !successfulResponse {
            let errorBody = errorBodyInterceptor(body, response)
            throw ApiRequestError.requestFailed(statusCode: statusCode, errorBody: errorBody)
        }
    }
    
    private func isSuccessStatusCode(statusCode: Int) -> Bool {
        return (200...299).contains(statusCode)
    }
}
