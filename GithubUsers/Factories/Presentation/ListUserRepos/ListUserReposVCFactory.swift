//
//  ListUserReposVCFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import UIKit

@MainActor
class ListUserReposVCFactory {
    class func make(userLogin: String) -> UIViewController {
        let viewModel = ListUserReposViewModelFactory.make(userLogin: userLogin)
        return ListUserReposVC(viewModel: viewModel)
    }
}
