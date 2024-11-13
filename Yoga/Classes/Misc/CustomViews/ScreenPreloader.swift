//
//  ScreenPreloader.swift
//  Soccer
//
//  Created by Андрей Чернышев on 12.03.2023.
//

import UIKit

final class ScreenPreloader: UIView {
    lazy var spinner = makeSpinner()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ScreenPreloader {
    func startAnimating() {
        spinner.startAnimating()
        isHidden = false
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
        isHidden = true
    }
}

// MARK: Private
private extension ScreenPreloader {
    func initialize() {
        backgroundColor = Appearance.main100.withAlphaComponent(0.6)
    }
}

// MARK: Make constraints
private extension ScreenPreloader {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ScreenPreloader {
    func makeSpinner() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
