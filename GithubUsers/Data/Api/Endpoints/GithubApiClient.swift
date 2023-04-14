//
//  GithubApiClient.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import Foundation

class GithubApiClient {
    class func instance()-> ApiClient {
        let builder = ApiClientBuilder(baseUrl: "https://api.github.com/")
            .addErrorBodyInterceptor { data, response in
                return data
            }
            .withDecoder { decoder in
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }
        return builder.build()
    }
}
