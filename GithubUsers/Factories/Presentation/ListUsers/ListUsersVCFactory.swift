//
//  ListUsersVCFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit
@MainActor
class ListUsersVCFactory {
    class func make() -> UIViewController {
        let viewModel = ListUsersViewModelFactory.make()
        return ListUsersVC(viewModel: viewModel)
    }
}
