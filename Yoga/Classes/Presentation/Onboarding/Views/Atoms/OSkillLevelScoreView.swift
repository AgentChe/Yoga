//
//  OSkillLevelScoreView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import UIKit

final class OSkillLevelScoreView: UIView {
    lazy var marked = (false, false) {
        didSet {
            update()
        }
    }
    
    let level: SkillLevel
    
    lazy var scoreView = makeScoreView()
    lazy var label = makeLabel()
    
    init(level: SkillLevel) {
        self.level = level
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSkillLevelScoreView {
    func update() {
        let (marked, target) = marked
        
        scoreView.backgroundColor = marked ? Appearance.main400 : Appearance.main200
        
        scoreView.layer.borderWidth = marked ? 0 : 1.scale
        scoreView.layer.borderColor = marked ? UIColor.clear.cgColor : Appearance.mono200.withAlphaComponent(0.1).cgColor
        
        label.isHidden = !target
    }
}

// MARK: Make constraints
private extension OSkillLevelScoreView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scoreView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scoreView.topAnchor.constraint(equalTo: topAnchor),
            scoreView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OSkillLevelScoreView {
    func makeScoreView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(25.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = level.name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
