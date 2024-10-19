//
//  ListUserReposVC.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import UIKit
import Combine
import FirebaseAnalytics

class ListUserReposVC: UIViewController {

    private let viewModel: any ListUserReposViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: any ListUserReposViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentView: ListUserReposView = {
        return ListUserReposView()
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
        loadUserRepos()
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
                           parameters: [AnalyticsParameterScreenName: "user-repositories"])
    }
    
    private func setUpUI() {
        title = "Repositories"
        contentView.setUpWith(datasource: self, delegate: self, loadStatusViewDelegate: self)
    }
    
    private func setUpObservers() {
        viewModel.reposPublisher.receive(on: RunLoop.main)
            .sink { [weak self] (_) in
                self?.contentView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.executionStatusPublisher.receive(on: RunLoop.main)
            .sink { [weak self] (status) in
                self?.contentView.updateForStatus(executionStatus: status)
            }.store(in: &cancellables)
    }
    
    private func loadUserRepos() {
        Task(priority: .userInitiated) {
            await viewModel.loadUserRepos()
        }
    }
}

//MARK: - UITableViewDataSource

extension ListUserReposVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfRepos()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repo = viewModel.repoAtIndex(indexPath.section),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SmallRepoInfoTableViewCell.self), for: indexPath) as? SmallRepoInfoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setUpWith(model: SmallRepoInfoView.Model(
            name: repo.name,
            fullName: repo.fullName,
            watchersCount: repo.watchersCount,
            canShowDetails: repo.htmlUrl != nil,
            forks: repo.forks,
            isPrivate: repo.isPrivate,
            openIssues: repo.openIssues,
            createdAt: repo.createdAt
        ))
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ListUserReposVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = viewModel.repoAtIndex(indexPath.section)?.htmlUrl else {
            return
        }
        
        tryToShowUserRepoDetails(pageUrl: url)
    }
    
    private func tryToShowUserRepoDetails(pageUrl: String) {
        guard let url = URL(string: pageUrl), UIApplication.shared.canOpenURL(url) else {
            showFailedToShowDetailsAlert(url: pageUrl)
            return
        }
        UIApplication.shared.open(url) { success in
            if !success {
                DispatchQueue.main.async { [weak self] in
                    self?.showFailedToShowDetailsAlert(url: pageUrl)
                }
            }
        }
    }
    
    private func showFailedToShowDetailsAlert(url: String) {
        let alert = UIAlertController(
            title: "Show details",
            message: "It was not possible to open details URL, \(url)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        showDetailViewController(alert, sender: self)
    }
}

//MARK: - LoadResultStatusViewDelegate

extension ListUserReposVC: LoadResultStatusViewDelegate {
    func onActionButtonPressed(currentStatus: LoadResultStatusView.Status) {
        switch(currentStatus) {
        case .noData, .failed:
            loadUserRepos()
        default:
            break
        }
    }
}
