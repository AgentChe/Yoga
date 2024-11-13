//
//  ProfileMainProgressView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 27.04.2023.
//

import UIKit

final class ProfileMainProgressView: UIView {
    lazy var label = makeLabel()
    
    private lazy var attrs = makeAttrs()
    
    private lazy var circleLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 140.scale, height: 140.scale)
    }
}

// MARK: Public
extension ProfileMainProgressView {
    func setup(percent: Int) {
        trackLayer.strokeEnd = CGFloat(percent) / 100
        
        let string = String(format: "%i%%", percent)
        label.attributedText = string.attributed(with: attrs)
    }
}


// MARK: Private
private extension ProfileMainProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: intrinsicContentSize.width / 2,
                                                           y: intrinsicContentSize.height / 2),
                                        radius: (intrinsicContentSize.width - 15.scale) / 2,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 6.scale
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = Appearance.main200.cgColor
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = 6.scale
        trackLayer.strokeStart = 0
        trackLayer.strokeEnd = 0
        trackLayer.strokeColor = Appearance.main400.cgColor

        layer.addSublayer(circleLayer)
        layer.addSublayer(trackLayer)
    }
}

// MARK: Make constraints
private extension ProfileMainProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileMainProgressView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.PlusJakartaSans.bold(size: 32.scale))
            .lineHeight(38.4.scale)
            .textAlignment(.center)
    }
}
