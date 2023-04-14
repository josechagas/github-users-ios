//
//  SmallRepoInfoTableViewCell.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import UIKit


class SmallRepoInfoTableViewCell: UITableViewCell {
    private lazy var content: SmallRepoInfoView = {
        let view = SmallRepoInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    func addSubviews() {
        contentView.addSubview(content)
    }
    
    func addConstraints() {
        let verticalPadding: CGFloat = 20
        let horizontalPadding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                constant: horizontalPadding
            ),
            content.topAnchor.constraint(
                greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.topAnchor,
                constant: verticalPadding
            ),
            content.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                constant: -horizontalPadding
            ),
            content.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor,
                constant: -verticalPadding
            ),
            content.centerYAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.centerYAnchor
            )
        ])
    }
    
    func setUpWith(model: SmallRepoInfoView.Model) {
        content.setUpWith(model: model)
    }

}
