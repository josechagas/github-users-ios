//
//  SearchUsersTableViewManager.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import UIKit

@MainActor
class SearchUsersTableViewManager: NSObject {
    let viewModel: ()-> SearchUsersViewModelProtocol?
    let onItemSelected: (SmallUserInfo)-> Void
    
    init(viewModel:@escaping ()-> SearchUsersViewModelProtocol?,
         onItemSelected: @escaping (SmallUserInfo)-> Void
    ) {
        self.viewModel = viewModel
        self.onItemSelected = onItemSelected
        super.init()
    }
}

//MARK: - UITableViewDataSource

extension SearchUsersTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel()?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = viewModel()?.itemAtIndex(index: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageAndTitleInfoTableViewCell.self), for: indexPath) as? ImageAndTitleInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.setUpWith(model: ImageAndTitleInfoView.Model(
            image: user.avatarUrl, title: user.login
        ))
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SearchUsersTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = viewModel()?.itemAtIndex(index: indexPath.row) else {
            return
        }
        onItemSelected(item)
    }
}
