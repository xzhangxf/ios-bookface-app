//
//  UserTableViewCell.swift
//  Face Book
//
//  Created by Xufeng Zhang on 16/10/25.
//

import UIKit

final class UserTableViewCell: UITableViewCell {
    static let reuseID = "UserCell"

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .preferredFont(forTextStyle: .headline)
        l.numberOfLines = 1
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .preferredFont(forTextStyle: .subheadline)
        l.textColor = .secondaryLabel
        l.numberOfLines = 2
        return l
    }()

    private let spinner: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.hidesWhenStopped = true
        return v
    }()

    private let labelsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 4
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .default
        accessoryType = .disclosureIndicator

        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(labelsStack)
        contentView.addSubview(spinner)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 44),
            avatarImageView.heightAnchor.constraint(equalToConstant: 44),

            avatarImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            labelsStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            labelsStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            labelsStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            spinner.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])

        avatarImageView.image = UIImage(systemName: "person.crop.circle")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        spinner.stopAnimating()
        avatarImageView.image = UIImage(systemName: "person.crop.circle")
    }


    func configure(name: String, email: String, age: Int) {
        titleLabel.text = name
        subtitleLabel.text = "\(email)\nAge: \(age)"
    }

    func startImageLoading() {
        spinner.startAnimating()
        avatarImageView.image = UIImage(systemName: "person.crop.circle")
    }

    func setImage(_ image: UIImage?) {
        spinner.stopAnimating()
        if let img = image {
            avatarImageView.image = img
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
}
