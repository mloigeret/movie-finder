//
//  MovieTableViewCell.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let containerPadding: CGFloat = 5
        static let padding: CGFloat = 5
        static let placeholderImage = UIImage(systemName: "film")?.withRenderingMode(.alwaysTemplate)
    }
    
    private var _isSetup: Bool = false
    
    private let _containerView = UIView()
    private let _posterImv = UIDownloadableImageView()
    private let _titleLabel = UILabel()
    private let _overviewLabel = UILabel()

    override func layoutSubviews() {
        setupIfNecessary()
        super.layoutSubviews()
    }
    
    private func setupIfNecessary() {
        guard !_isSetup else { return }
        _isSetup = true
        setupComponents()
        setupLayout()
    }
    
    private func setupComponents() {
        _containerView.layer.cornerRadius = 8
        _containerView.clipsToBounds = true
        _containerView.backgroundColor = .lightGray
        _posterImv.contentMode = .scaleAspectFill
        _titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        _titleLabel.textColor = .black
        _overviewLabel.font = UIFont.systemFont(ofSize: 12)
        _overviewLabel.numberOfLines = 0
        _overviewLabel.lineBreakMode = .byWordWrapping
        
        _posterImv.tintColor = .white
        _posterImv.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        _posterImv.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        _overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(_containerView)
        _containerView.addSubview(_posterImv)
        _containerView.addSubview(_titleLabel)
        _containerView.addSubview(_overviewLabel)
        
        NSLayoutConstraint.activate([
            _containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.containerPadding),
            _containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.containerPadding),
            _containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.containerPadding),
            _containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.containerPadding),
            
            _posterImv.leftAnchor.constraint(equalTo: _containerView.leftAnchor, constant: Constants.padding),
            _posterImv.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: Constants.padding),
            _posterImv.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor, constant: -Constants.padding),
            _posterImv.heightAnchor.constraint(equalTo: _posterImv.widthAnchor, multiplier: 1.5),
            
            _titleLabel.leftAnchor.constraint(equalTo: _posterImv.rightAnchor, constant: Constants.padding),
            _titleLabel.rightAnchor.constraint(equalTo: _containerView.rightAnchor, constant: -Constants.padding),
            _titleLabel.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: Constants.padding),
            _titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            _overviewLabel.leftAnchor.constraint(equalTo: _titleLabel.leftAnchor),
            _overviewLabel.rightAnchor.constraint(equalTo: _titleLabel.rightAnchor),
            _overviewLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: Constants.padding),
            _overviewLabel.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    func configure(model: MovieSearchResult) {
        _titleLabel.text = model.title
        _overviewLabel.text = model.overview
        _posterImv.downloadImageFrom(urlString: model.fullPosterPath,
                                     placeholder: Constants.placeholderImage,
                                     imageMode: .scaleAspectFit)
    }
}
