//
//  GithubApiClient.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

class GithubApiClient {
    class func instance()-> ApiClient {
        var builder = ApiClientBuilder(baseUrl: "https://api.github.com/")
            .addErrorBodyInterceptor { data, response in
                return data
            }
        return builder.build()
    }
}
