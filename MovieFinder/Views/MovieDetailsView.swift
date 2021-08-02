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
    private var _castLabel = UILabel()
    private var _crewLabel = UILabel()

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
        
        _castLabel.font = UIFont.systemFont(ofSize: 12)
        _castLabel.numberOfLines = 0
        _castLabel.lineBreakMode = .byWordWrapping
        
        _crewLabel.font = UIFont.systemFont(ofSize: 12)
        _crewLabel.numberOfLines = 0
        _crewLabel.lineBreakMode = .byWordWrapping
    }
    
    private func configureLayout() {
        _posterImv.translatesAutoresizingMaskIntoConstraints = false
        _overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        _castLabel.translatesAutoresizingMaskIntoConstraints = false
        _crewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(_posterImv)
        addSubview(_overviewLabel)
        addSubview(_castLabel)
        addSubview(_crewLabel)

        NSLayoutConstraint.activate([
            _posterImv.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.padding),
            _posterImv.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.padding),
            _posterImv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.padding),
            _posterImv.heightAnchor.constraint(equalTo: _posterImv.widthAnchor, multiplier: 1.5),

            _overviewLabel.topAnchor.constraint(equalTo: _posterImv.topAnchor),
            _overviewLabel.leftAnchor.constraint(equalTo: _posterImv.rightAnchor, constant: Constants.padding),
            _overviewLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.padding),
            _overviewLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            
            _castLabel.topAnchor.constraint(equalTo: _overviewLabel.bottomAnchor, constant: Constants.padding),
            _castLabel.leftAnchor.constraint(equalTo: _overviewLabel.leftAnchor),
            _castLabel.rightAnchor.constraint(equalTo: _overviewLabel.rightAnchor),
            
            _crewLabel.topAnchor.constraint(equalTo: _castLabel.bottomAnchor, constant: Constants.padding),
            _crewLabel.leftAnchor.constraint(equalTo: _castLabel.leftAnchor),
            _crewLabel.rightAnchor.constraint(equalTo: _castLabel.rightAnchor),
            _crewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding),
            _crewLabel.heightAnchor.constraint(equalTo: _castLabel.heightAnchor)
        ])
    }
    
    func configure(model: MovieDetails) {
        let placeholderImage = UIImage(systemName: "film")?.withRenderingMode(.alwaysTemplate)
        _overviewLabel.text = model.overview
        _posterImv.tintColor = .white
        _posterImv.contentMode = .scaleAspectFit

        _posterImv.downloadImageFrom(urlString: model.fullPosterPath,
                                     placeholder: placeholderImage,
                                     imageMode: .scaleAspectFit)
        
        _castLabel.text = "Cast: " + (model.castString ?? "...")
        _crewLabel.text = "Crew: " + (model.crewString ?? "...")
    }
}
