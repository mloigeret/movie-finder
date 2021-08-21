//
//  MovieTableViewCell.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let padding: CGFloat = 5
        static let placeholderImage = UIImage(systemName: "film")?.withRenderingMode(.alwaysTemplate)
    }
    
    private let _posterImv = UIDownloadableImageView()
    private let _titleLabel = UILabel()
    private let _overviewLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupComponents()
        setupLayout()
    }
    
    func setupComponents() {
        _titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        _overviewLabel.font = UIFont.systemFont(ofSize: 12)
        _overviewLabel.numberOfLines = 0
        _overviewLabel.lineBreakMode = .byWordWrapping
    }
    
    func setupLayout() {
        _posterImv.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        _overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(_posterImv)
        contentView.addSubview(_titleLabel)
        contentView.addSubview(_overviewLabel)
        
        NSLayoutConstraint.activate([
            _posterImv.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.padding),
            _posterImv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            _posterImv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            _posterImv.heightAnchor.constraint(equalTo: _posterImv.widthAnchor, multiplier: 1.5),
            
            _titleLabel.leftAnchor.constraint(equalTo: _posterImv.rightAnchor, constant: Constants.padding),
            _titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.padding),
            _titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            _titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            _overviewLabel.leftAnchor.constraint(equalTo: _titleLabel.leftAnchor),
            _overviewLabel.rightAnchor.constraint(equalTo: _titleLabel.rightAnchor),
            _overviewLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: Constants.padding),
            _overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    func configure(movie: MovieSearchResult) {
        _titleLabel.text = movie.title
        _overviewLabel.text = movie.overview
        _posterImv.downloadImageFrom(urlString: movie.fullPosterPath,
                                     placeholder: Constants.placeholderImage,
                                     imageMode: .scaleAspectFill)
    }
}
