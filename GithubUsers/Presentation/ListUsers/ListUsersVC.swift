//
//  ListUsersVC.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import UIKit
import Combine
import FirebaseAnalytics

class ListUsersVC: UIViewController {

    private let viewModel: any ListUsersViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: any ListUsersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var contentView: ListUsersView = {
        return ListUsersView()
    }()
        
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpObservers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }
    
    override func viewDidDismissModal(viewWasOutOfWindow: Bool) {
        super.viewDidDismissModal(viewWasOutOfWindow: viewWasOutOfWindow)
        if !viewWasOutOfWindow {
            trackScreenView()
        }
    }
    
    private func trackScreenView() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "users"])
    }
    
    private func setUpUI() {
        title = "Users"
        contentView.setUpWith(datasource: self, delegate: self, loadStatusViewDelegate: self)
    }
    
    private func setUpObservers() {
        viewModel.users.receive(on: RunLoop.main)
            .sink { [weak self] (_) in
                self?.contentView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.executionStatus.receive(on: RunLoop.main)
            .sink { [weak self] (status) in
                self?.contentView.updateForStatus(executionStatus: status)
            }.store(in: &cancellables)
    }
    
    private func loadUsers() {
        Task(priority: .userInitiated) {
            await viewModel.loadUsers()
        }
    }
}

//MARK: - UITableViewDataSource

extension ListUsersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = viewModel.userAtIndex(indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageAndTitleInfoTableViewCell.self), for: indexPath) as? ImageAndTitleInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.setUpWith(model: ImageAndTitleInfoView.Model(
            image: user.avatarUrl, title: user.login
        ))
        return cell
    }
}

extension ListUsersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let user = viewModel.userAtIndex(indexPath.row) {
            let userDetailsVC = UserDetailsVCFactory.make(userLogin: user.login)
            //show(userDetailsVC, sender: self)
            showDetailViewController(userDetailsVC, sender: self)
        }
    }
}


//MARK: - LoadStatusViewDelegate

extension ListUsersVC: LoadResultStatusViewDelegate {
    func onActionButtonPressed(currentStatus: LoadResultStatusView.Status) {
        switch(currentStatus) {
        case .noData:
            loadUsers()
        case .failed:
            loadUsers()
        default:
            break
        }
    }
}
