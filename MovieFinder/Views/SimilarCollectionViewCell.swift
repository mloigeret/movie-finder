//
//  SimilarCollectionViewCell.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-08-02.
//

import UIKit

class SimilarCollectionViewCell: UICollectionViewCell {
    
    private struct Constants {
        static let padding: CGFloat = 10
        static let placeholderImage = UIImage(systemName: "film")?.withRenderingMode(.alwaysTemplate)
    }
    
    private var _isSetup: Bool = false
    private let _titleLabel = UILabel()
    private let _posterImv = UIDownloadableImageView()
    
    
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
        _titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        _titleLabel.numberOfLines = 2
    }
    
    private func setupLayout() {
        _posterImv.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(_posterImv)
        contentView.addSubview(_titleLabel)
        
        NSLayoutConstraint.activate([
            _posterImv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            _posterImv.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.padding),
            _posterImv.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.padding),
            _posterImv.heightAnchor.constraint(equalTo: _posterImv.widthAnchor, multiplier: 1.5),
            
            _titleLabel.topAnchor.constraint(equalTo: _posterImv.bottomAnchor, constant: Constants.padding),
            _titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -Constants.padding),
            _titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: Constants.padding),
            _titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -Constants.padding),
        ])
    }
    
    func configure(movieSearchResult: MovieSearchResult) {
        _titleLabel.text = movieSearchResult.title
        _posterImv.downloadImageFrom(urlString: movieSearchResult.fullPosterPath,
                                     placeholder: Constants.placeholderImage,
                                     imageMode: .scaleAspectFill)
    }
}
