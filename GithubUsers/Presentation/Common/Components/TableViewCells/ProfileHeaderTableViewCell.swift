//
//  ProfileHeaderTableViewCell.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    private lazy var content: ProfileHeaderView = {
        let view = ProfileHeaderView()
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
        let horizontalPadding: CGFloat = 10
        
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
    
    func setUpWith(model: ProfileHeaderView.Model) {
        content.setUp(model: model)
    }

}
