//
//  ImageAndTitleInfoView.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit
import SDWebImage

class ImageAndTitleInfoView: UIView, WithViewCode {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    func addConstraints() {
        addImageViewConstraints()
        addTitleLabelConstraints()
    }
    
    func addImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func addTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
    
    func setUpWith(model: ImageAndTitleInfoView.Model) {
        titleLabel.text = model.title
        if let imageUrl = model.image {
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
        }
    }
}

extension ImageAndTitleInfoView {
    struct Model {
        let image: String?
        let title: String
    }
}
