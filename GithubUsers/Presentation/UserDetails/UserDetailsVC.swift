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
    
    private lazy var tableViewManager: UserDetailsVCTableViewManager = {
        UserDetailsVCTableViewManager { [weak self] in
            self?.viewModel
        } showRepositoriesAction: { [weak self] in
            self?.showRepositories()
        }
    }()

    init(viewModel: any UserDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
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
        loadUser()
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
        print("mostrou detalhes do usuário")
    }
    
    private func setUpUI() {
        title = viewModel.userLogin
        contentView.setUpWith(datasource: tableViewManager, delegate: tableViewManager, loadStatusViewDelegate: self)
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
    
    private func loadUser() {
        Task(priority: .userInitiated) {
            await viewModel.loadUserDetails()
        }
    }
    
    private func showRepositories() {
//        let presentingVC = presentingViewController
//        dismiss(animated: true) { [weak self] in
//            guard let self else { return }
//            let vc = ListUserReposVCFactory.make(userLogin: viewModel.userLogin)
//            presentingVC?.show(vc, sender: self)
//        }

        let vc = ListUserReposVCFactory.make(userLogin: viewModel.userLogin)
        show(vc, sender: self)
        //dismiss(animated: true)
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

