//
//  TryAgainView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class TryAgainView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tryAgainButton = makeButton()
    lazy var contactButton = makeContactButton()
    
    private let error: Error
    
    init(error: Error) {
        self.error = error

        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TryAgainView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    func errorMessage() -> String {
         guard let networkError = error as? NetworkError else {
             return "TryAgain.SubTitle".localized
         }

         switch networkError.code {
         case .serverNotAvailable:
             return "TryAgain.SubTitle".localized
         case .logical(let message):
             return message
         }
     }
}

// MARK: Make constraints
private extension TryAgainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 268.scale),
            imageView.heightAnchor.constraint(equalToConstant: 177.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tryAgainButton.widthAnchor.constraint(equalToConstant: 343.scale),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 54.scale),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.bottomAnchor.constraint(equalTo: contactButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            contactButton.widthAnchor.constraint(equalToConstant: 343.scale),
            contactButton.heightAnchor.constraint(equalToConstant: 54.scale),
            contactButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            contactButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TryAgainView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TryAgain.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.scale)
            .letterSpacing(-0.3.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TryAgain.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.regular(size: 17.scale))
            .lineHeight(27.2.scale)
            .letterSpacing(-0.41.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = errorMessage().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("TryAgain.Button".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContactButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("TryAgain.Contact".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
