//
//  ODayOfWeekButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import UIKit

final class ODayOfWeekButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
    let dayOfWeek: DayOfWeek
    
    private lazy var dAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    private lazy var sAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    
    init(dayOfWeek: DayOfWeek) {
        self.dayOfWeek = dayOfWeek
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = max(frame.width, frame.height) / 2
    }
}

// MARK: Private
private extension ODayOfWeekButton {
    func update() {
        backgroundColor = marked ? Appearance.main400 : Appearance.main200
        
        let attrs = marked ? sAttrs : dAttrs
        label.attributedText = text.attributed(with: attrs)
    }
    
    var text: String {
        switch dayOfWeek {
        case .su:
            return "Onboarding.DaysOfWeek.Su".localized
        case .mo:
            return "Onboarding.DaysOfWeek.Mo".localized
        case .tu:
            return "Onboarding.DaysOfWeek.Tu".localized
        case .we:
            return "Onboarding.DaysOfWeek.We".localized
        case .th:
            return "Onboarding.DaysOfWeek.Th".localized
        case .fr:
            return "Onboarding.DaysOfWeek.Fr".localized
        case .sa:
            return "Onboarding.DaysOfWeek.Sa".localized
        }
    }
}

// MARK: Make constraints
private extension ODayOfWeekButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ODayOfWeekButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
