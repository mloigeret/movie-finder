//
//  MovieDetailsView.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-08-02.
//

import UIKit

class MovieDetailsView: UIView {
    
    private struct Constants {
        static let padding: CGFloat = 10
    }
    
    private var _posterImv = UIDownloadableImageView()
    private var _overviewLabel = UILabel()

    init() {
        super.init(frame: .zero)
        configureProperties()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProperties() {
        
        _overviewLabel.font = UIFont.systemFont(ofSize: 12)
        _overviewLabel.numberOfLines = 0
        _overviewLabel.lineBreakMode = .byWordWrapping
        
    }
    
    private func configureLayout() {
        _posterImv.translatesAutoresizingMaskIntoConstraints = false
        _overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(_posterImv)
        addSubview(_overviewLabel)

        NSLayoutConstraint.activate([
            _posterImv.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.padding),
            _posterImv.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.padding),
            _posterImv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.padding),
            _posterImv.heightAnchor.constraint(equalTo: _posterImv.widthAnchor, multiplier: 1.5),

            _overviewLabel.topAnchor.constraint(equalTo: _posterImv.topAnchor),
            _overviewLabel.leftAnchor.constraint(equalTo: _posterImv.rightAnchor, constant: Constants.padding),
            _overviewLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.padding),
            _overviewLabel.bottomAnchor.constraint(equalTo: _posterImv.bottomAnchor)
        ])
    }
    
    func configure(model: MovieSearchResult) {
        let placeholderImage = UIImage(systemName: "film")?.withRenderingMode(.alwaysTemplate)
        _overviewLabel.text = model.overview
        _posterImv.tintColor = .white
        _posterImv.contentMode = .scaleAspectFit

        _posterImv.downloadImageFrom(urlString: model.fullPosterPath,
                                     placeholder: placeholderImage,
                                     imageMode: .scaleAspectFit)
    }
}
