//
//  UserDetailsVCTableViewManager.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit

@MainActor
class UserDetailsVCTableViewManager: NSObject {
        
    private var viewModel: ()-> (any UserDetailsViewModelProtocol)?
    private var showRepositoriesAction: ()-> Void
    private var cancelAction: ()-> Void

    private var numberOfSections: Int = 3
    private var showRepositoresCellIndexPath = IndexPath(row: 0, section: 2)
    private var cancelCellIndexPath = IndexPath(row: 1, section: 2)

    private var hasData: Bool {
        viewModel()?.user != nil
    }
    
    init(viewModel: @escaping ()-> (any UserDetailsViewModelProtocol)?, showRepositoriesAction: @escaping ()-> Void, cancelAction: @escaping ()-> Void) {
        self.viewModel = viewModel
        self.showRepositoriesAction = showRepositoriesAction
        self.cancelAction = cancelAction
    }
}

//MARK: - UITableViewDataSource

extension UserDetailsVCTableViewManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard hasData else {
            return 0
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard hasData else {
            return 0
        }
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 4
        } else if section == 2 {
            return 2
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = viewModel()?.user, indexPath.section <= numberOfSections - 1 else {
            return UITableViewCell()
        }
        
        if indexPath == IndexPath(row: 0,section: 0) {
            return dequeueProfileHeaderCell(tableView: tableView, indexPath: indexPath, user: user)
            
        } else if indexPath.section == 1 {
            let (title, value) = titleValueForCell(row: indexPath.row, user: user)
            return dequeueValueCell(tableView: tableView, indexPath: indexPath, title: title, value: value)
            
        } else if indexPath == showRepositoresCellIndexPath {
            return dequeueButtonActionCell(tableView: tableView, indexPath: indexPath, actionTitle: "Repositories")
        } else if indexPath == cancelCellIndexPath {
            return dequeueButtonActionCell(tableView: tableView, indexPath: indexPath, actionTitle: "Cancel")

        }
        
        return UITableViewCell()
    }

    
    private func dequeueProfileHeaderCell(tableView: UITableView, indexPath: IndexPath, user: User) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileHeaderTableViewCell.self), for: indexPath) as? ProfileHeaderTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setUpWith(model: ProfileHeaderView.Model(
            imageUrl: user.avatarUrl,
            name: user.name ?? user.login.capitalized,
            login: user.login,
            email: user.email,
            company: user.company,
            bio: user.bio
        ))
        
        return cell
    }
    
    private func dequeueValueCell(tableView: UITableView, indexPath: IndexPath, title: String, value: String?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        
        var content = UIListContentConfiguration.valueCell()
        content.text = title
        content.secondaryText = value
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func dequeueButtonActionCell(tableView: UITableView, indexPath: IndexPath, actionTitle: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        
        var content = UIListContentConfiguration.cell()
        content.text = actionTitle
        content.textProperties.alignment = .center
        content.textProperties.color = UIColor.link
        cell.contentConfiguration = content
        
        return cell
    }
    
    private func titleValueForCell(row: Int, user: User) -> (String, String?) {
        switch(row) {
        case 0 :
            return ("Public repositores", "\(user.numberOfPublicRepos)")
        case 1:
            return ("Public gists", "\(user.numberOfPublicGists)")
        case 2:
            return ("Followers", "\(user.followers)")
        case 3:
            return ("Following", "\(user.following)")
        default:
            return ("", nil)
        }
    }
}

//MARK: - UITableViewDelegate

extension UserDetailsVCTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == showRepositoresCellIndexPath {
            showRepositoriesAction()
        } else if indexPath == cancelCellIndexPath {
            cancelAction()
        }
    }
}
