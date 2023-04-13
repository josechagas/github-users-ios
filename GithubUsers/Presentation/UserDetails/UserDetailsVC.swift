//
//  UserDetailsVC.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit
import Combine

class UserDetailsVC: UIViewController {
    private let viewModel: any UserDetailsViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: any UserDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var contentView: UserDetailsView = {
        return UserDetailsView()
    }()
        
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setUpUI() {
        title = viewModel.userLogin
        contentView.setUpWith(datasource: self, delegate: self, loadStatusViewDelegate: self)
    }
    
    private func setUpObservers() {
        viewModel.user.receive(on: RunLoop.main)
            .sink { [weak self] (_) in
                self?.contentView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.executionStatus.receive(on: RunLoop.main)
            .sink { [weak self] (status) in
                self?.contentView.updateForStatus(executionStatus: status)
            }.store(in: &cancellables)
    }
    
    private func loadUser() {
        Task(priority: .userInitiated) {
            await viewModel.loadUserDetails()
        }
    }
}

//MARK: - UITableViewDataSource

extension UserDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        
        var content = UIListContentConfiguration.valueCell()
        content.text = "Login"
        content.secondaryText = viewModel.userLogin
        cell.contentConfiguration = content

        return cell
    }
}

extension UserDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - LoadStatusViewDelegate

extension UserDetailsVC: LoadResultStatusViewDelegate {
    func onActionButtonPressed(currentStatus: LoadResultStatusView.Status) {
        switch(currentStatus) {
        case .noData:
            loadUser()
        case .failed:
            loadUser()
        default:
            break
        }
    }
}

