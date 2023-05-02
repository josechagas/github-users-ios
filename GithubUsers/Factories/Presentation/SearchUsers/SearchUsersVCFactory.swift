//
//  SearchUsersVCFactory.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import UIKit

@MainActor
class SearchUsersVCFactory {
    class func make()-> UIViewController {
        let viewModel = SearchUsersViewModelFactory.make()
        return SearchUsersVC(viewModel: viewModel)
    }
}
