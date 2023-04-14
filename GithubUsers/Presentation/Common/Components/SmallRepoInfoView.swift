//
//  SmallRepoInfoView.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import UIKit


class SmallRepoInfoView: UIView, WithViewCode {
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .title1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .callout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .callout)
        view.textColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var watchersCountView: TitleValueView = {
        let view = TitleValueView()
        view.setTitle(title: "Watchers")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var forksCountView: TitleValueView = {
        let view = TitleValueView()
        view.setTitle(title: "Forks")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var openIssuesCountView: TitleValueView = {
        let view = TitleValueView()
        view.setTitle(title: "Open Issues")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var showDetailsViewIndicator: UILabel = {
        let view = UILabel()
        view.text = "Open"
        view.textAlignment = .center
        view.textColor = UIColor.link
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleValueViewsSpaceBetween: CGFloat = 5
    private var onShowDetailButtonPressed: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        addSubviews()
        addConstraints()
    }
    
    func setUpWith(model: SmallRepoInfoView.Model) {
        nameLabel.text = model.name
        fullNameLabel.text = model.fullName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        createdAtLabel.text = formatter.string(from: model.createdAt)
        
        watchersCountView.setValue(value: "\(model.watchersCount)")
        forksCountView.setValue(value: "\(model.forks)")
        openIssuesCountView.setValue(value: "\(model.openIssues)")
        
        showDetailsViewIndicator.isEnabled = model.canShowDetails
    }
}

//MARK: - Constraints

extension SmallRepoInfoView {
    func addSubviews() {
        addSubview(nameLabel)
        addSubview(fullNameLabel)
        addSubview(createdAtLabel)
        addSubview(divider)
        addSubview(watchersCountView)
        addSubview(forksCountView)
        addSubview(openIssuesCountView)
        addSubview(showDetailsViewIndicator)
    }
    
    func addConstraints() {
        addNameLabelConstraints()
        addFullnameLabelConstraints()
        addCreatedAtLabelConstraints()
        addDividerViewConstraints()
        addWatchersCountViewConstraints()
        addForksCountViewConstraints()
        addOpenIssuesViewConstraints()
        addShowDetailsViewConstraints()
    }
    
    private func addNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func addFullnameLabelConstraints() {
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            fullNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addCreatedAtLabelConstraints() {
        NSLayoutConstraint.activate([
            createdAtLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
            createdAtLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            createdAtLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addDividerViewConstraints() {
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor, constant: 20),
            divider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func addWatchersCountViewConstraints() {
        NSLayoutConstraint.activate([
            watchersCountView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20),
            watchersCountView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            watchersCountView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addForksCountViewConstraints() {
        NSLayoutConstraint.activate([
            forksCountView.topAnchor.constraint(equalTo: watchersCountView.bottomAnchor, constant: titleValueViewsSpaceBetween),
            forksCountView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            forksCountView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func addOpenIssuesViewConstraints() {
        NSLayoutConstraint.activate([
            openIssuesCountView.topAnchor.constraint(equalTo: forksCountView.bottomAnchor, constant: titleValueViewsSpaceBetween),
            openIssuesCountView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            openIssuesCountView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func addShowDetailsViewConstraints() {
        NSLayoutConstraint.activate([
            showDetailsViewIndicator.topAnchor.constraint(equalTo: openIssuesCountView.bottomAnchor, constant: 20),
            showDetailsViewIndicator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            showDetailsViewIndicator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            showDetailsViewIndicator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - SmallRepoInfoView.Model

extension SmallRepoInfoView {
    struct Model {
        let name: String
        let fullName: String
        let watchersCount: Int
        let canShowDetails: Bool
        let forks: Int
        let isPrivate: Bool
        let openIssues: Int
        let createdAt: Date
    }
}
