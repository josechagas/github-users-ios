//
//  SearchUsersVC.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import UIKit
import Combine

class SearchUsersVC: UIViewController {
    private let viewModel: SearchUsersViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    private lazy var searchUsersTVM: SearchUsersTableViewManager = {
        SearchUsersTableViewManager {[weak self] in
            self?.viewModel
        } onItemSelected: { [weak self] user in
            self?.onUserSelected(user: user)
        }
    }()
  
    init(viewModel: SearchUsersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentView: SearchUsersView = {
        return SearchUsersView()
    }()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpObservers()
    }
    
    private func setUpUI() {
        title = "Search"
        contentView.setUpWith(datasource: searchUsersTVM,
                              delegate: searchUsersTVM,
                              loadStatusViewDelegate: self,
                              searchBarDelegate: self
        )
    }
    
    private func setUpObservers() {
        viewModel.userPublisher.receive(on: RunLoop.main)
            .sink { [weak self] (_) in
                self?.contentView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.executionStatusPublisher.receive(on: RunLoop.main)
            .sink { [weak self] (status) in
                self?.contentView.updateForStatus(executionStatus: status)
            }.store(in: &cancellables)
    }
    
    private func searchUsersBy(_ search: String) {
        Task(priority: .userInitiated) { [weak self] in
            await self?.viewModel.searchUsersBy(search:search)
        }
    }
    
    private func retrySearch() {
        if let text = contentView.searchText() {
            searchUsersBy(text)
        }
    }
    
    private func onUserSelected(user: SmallUserInfo) {
        let userDetailsVC = UserDetailsVCFactory.make(userLogin: user.login)
        show(userDetailsVC, sender: self)
    }
}

//MARK: - LoadResultStatusViewDelegate

extension SearchUsersVC: LoadResultStatusViewDelegate {
    func onActionButtonPressed(currentStatus: LoadResultStatusView.Status) {
        switch currentStatus {
        case .noData:
            retrySearch()
        case .failed:
            retrySearch()
        default:
            break
        }
    }
}

//MARK: - UISearchBarDelegate

extension SearchUsersVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchUsersBy(text)
        }
    }
}
