//
//  ApiRequestMaker.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

protocol ApiRequestMaker {
    func makeRequest() -> ApiRequest
}
