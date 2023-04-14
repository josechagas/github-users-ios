//
//  ProfileHeaderView.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit

class ProfileHeaderView: UIStackView, WithViewCode {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 60
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .title1)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loginLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .callout)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private lazy var emailLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .callout)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var companyLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .callout)
        view.textAlignment = .center
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bioLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .callout)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        axis = .vertical
        alignment = .center
        distribution = .fill
        spacing = 10

        addSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        addArrangedSubview(imageView)
        addArrangedSubview(nameLabel)
        addArrangedSubview(loginLabel)
        addArrangedSubview(emailLabel)
        addArrangedSubview(companyLabel)
        addArrangedSubview(bioLabel)
    }
    
    func addConstraints() {
        addImageViewConstraints()
    }
    
    private func addImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    
    func setUp(model: ProfileHeaderView.Model) {
        if let imageUrl = model.imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
        }
        
        nameLabel.text = model.name
        loginLabel.text = model.login
        emailLabel.text = model.email
        companyLabel.text = model.company
        bioLabel.text = model.bio
        
        emailLabel.isHidden = model.email?.isEmpty ?? true
        companyLabel.isHidden = model.company?.isEmpty ?? true
        bioLabel.isHidden = model.bio?.isEmpty ?? true
    }
    
}

extension ProfileHeaderView {
    struct Model {
        let imageUrl: String?
        let name: String
        let login: String
        let email: String?
        let company: String?
        let bio: String?
    }
}
