//
//  CircleProgressView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class CircleProgressView: UIView {
    private lazy var circleLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    
    private var arcCenter: CGPoint
    private var radius: CGFloat
    private var lineWidth: CGFloat
    private var circleColor: UIColor
    private var trackColor: UIColor
    
    init(arcCenter: CGPoint,
         radius: CGFloat,
         lineWidth: CGFloat,
         circleColor: UIColor,
         trackColor: UIColor) {
        self.arcCenter = arcCenter
        self.radius = radius
        self.lineWidth = lineWidth
        self.circleColor = circleColor
        self.trackColor = trackColor
        
        super.init(frame: .zero)
        
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CircleProgressView {
    func setup(progress: Int) {
        trackLayer.strokeEnd = CGFloat(progress) / 100
    }
    
    func update(circleColor: UIColor) {
        self.circleColor = circleColor
        
        circleLayer.strokeColor = circleColor.cgColor
    }
    
    func update(trackColor: UIColor) {
        self.trackColor = trackColor
        
        trackLayer.strokeColor = trackColor.cgColor
    }
}

// MARK: Private
private extension CircleProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: arcCenter,
                                        radius: radius,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = circleColor.cgColor
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = lineWidth
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.strokeStart = 0
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(trackLayer)
    }
}
