//
//  UserDetailsViewModelFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation


@MainActor
class UserDetailsViewModelFactory {
    class func make(userLogin: String) -> any UserDetailsViewModelProtocol  {
        return UserDetailsViewModel(userLogin: userLogin)
    }
}
