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
    }
    
    private var _isSetup: Bool = false
    
    private let _posterImv = UIDownloadableImageView()
    private let _titleLabel = UILabel()
    private let _overviewLabel = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupIfNecessary()
    }
    
    private func setupIfNecessary() {
        guard !_isSetup else { return }
        _isSetup = true
        
        //components
        _posterImv.contentMode = .scaleAspectFill
        
        _titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        _titleLabel.textColor = .black
        _overviewLabel.font = UIFont.systemFont(ofSize: 12)
        _overviewLabel.numberOfLines = 0
        _overviewLabel.lineBreakMode = .byWordWrapping
        
        //layout
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
            _titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constants.padding),
            _titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            _titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            _overviewLabel.leftAnchor.constraint(equalTo: _titleLabel.leftAnchor),
            _overviewLabel.rightAnchor.constraint(equalTo: _titleLabel.rightAnchor),
            _overviewLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: Constants.padding),
            _overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    func configure(model: MovieCellModel) {
        _titleLabel.text = model.title
        _overviewLabel.text = model.overview
        if let url = model.imageURL {
            _posterImv.downloadImageFrom(url: url,
                                         imageMode: .scaleAspectFill)
        }
        backgroundColor = model.color
    }
}
