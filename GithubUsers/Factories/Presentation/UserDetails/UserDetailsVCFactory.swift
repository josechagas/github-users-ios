//
//  UserDetailsVCFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit

@MainActor
class UserDetailsVCFactory {
    class func make(userLogin: String) -> UIViewController {
        let viewModel = UserDetailsViewModelFactory.make(userLogin: userLogin)
        return UserDetailsVC(viewModel: viewModel)
    }
}
