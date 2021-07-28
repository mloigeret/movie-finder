//
//  UIDownloadableImageView.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-22.
//

import UIKit
import RxSwift

class UIDownloadableImageView: UIView {
    private let _imv = UIImageView()
    private let _imageCache = NSCache<NSString, AnyObject>()
    private let _imageURLObservable = BehaviorSubject<URL?>(value: nil)
    
    private let _disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        configureLayout()
        configureRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        _imv.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(_imv)

        NSLayoutConstraint.activate([
            _imv.leftAnchor.constraint(equalTo: self.leftAnchor),
            _imv.rightAnchor.constraint(equalTo: self.rightAnchor),
            _imv.topAnchor.constraint(equalTo: self.topAnchor),
            _imv.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureRx() {
        _imageURLObservable
            .flatMapLatest { url -> Observable<Data>  in
                guard let url = url else { return Observable.of(Data.init()) }
                let request = URLRequest.init(url: url)
                return URLSession.shared.rx.data(request: request)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] data in
                guard let img = UIImage(data: data) else { return }
                _imv.image = img
            })
            .disposed(by: _disposeBag)
    }
    
    func downloadImageFrom(urlString: String?,
                           placeholder: UIImage?,
                           imageMode: UIView.ContentMode) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url,
                          placeholder: placeholder,
                          imageMode: imageMode)
    }

    func downloadImageFrom(url: URL,
                           placeholder: UIImage?,
                           imageMode: UIView.ContentMode) {
        _imv.image = placeholder
        contentMode = imageMode
        if let cachedImage = _imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            _imv.image = cachedImage
        }
        else {
            _imageURLObservable.onNext(url)
        }
    }
}
