//
//  ApiRequest+ErrorHandling.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

//TODO: This is just an example, but must be moved to presentation layer for a better usage of architecture
extension ApiRequestError {
    var localizedMessage: String {
        let message: String
        switch self {
        case .invalidUrlPath:
            message = "Could not execute the request. Please try again later"
            
        case .unknownError:
            message = "Unexpected error. We are now working to fix it"

        case .requestFailed(let statusCode, _) where statusCode == 401:
            message = "Expired authentication. Please sign in again."

        case .requestFailed(let statusCode, _) where (500...599).contains(statusCode):
            message = ""

        default:
            message = "Could not execute the request. Please try again later"
        }
        return message
    }
}
