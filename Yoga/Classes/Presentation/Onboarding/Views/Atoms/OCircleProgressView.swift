//
//  OCircleProgressView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

import UIKit

final class OCircleProgressView: UIView {
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
        CGSize(width: 210.scale, height: 210.scale)
    }
}

// MARK: Public
extension OCircleProgressView {
    func setup(percent: Int) {
        trackLayer.strokeEnd = CGFloat(percent) / 100
        
        let string = String(format: "%i%%", percent)
        label.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Private
private extension OCircleProgressView {
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
        circleLayer.lineWidth = 15.scale
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = Appearance.main200.cgColor
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = 15.scale
        trackLayer.strokeStart = 0
        trackLayer.strokeEnd = 0
        trackLayer.strokeColor = Appearance.main300.cgColor

        layer.addSublayer(circleLayer)
        layer.addSublayer(trackLayer)
    }
}

// MARK: Make constraints
private extension OCircleProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OCircleProgressView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.PlusJakartaSans.bold(size: 45.scale))
            .lineHeight(54.46.scale)
            .textAlignment(.center)
    }
}
