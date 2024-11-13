//
//  ProgressSegmentView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 16.04.2023.
//

import UIKit

class ProgressSegmentView: UIView {
    var segmentCount: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    var spacing: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }

    var currentIndex: Int = 0 {
        didSet {
            animate()
        }
    }
    
    var progressColor: UIColor = Appearance.main300 {
        didSet {
            setNeedsLayout()
        }
    }
    private let progressLayer = CAShapeLayer()

    override func draw(_ rect: CGRect) {
        let segmentWidth = (rect.width - spacing * CGFloat(segmentCount - 1)) / CGFloat(max(segmentCount, 1))
        let beizerPath = UIBezierPath()

        for index in 0..<segmentCount {
            let segmentSize = CGSize(width: segmentWidth, height: rect.height)
            let origin = CGPoint(x: (segmentWidth + spacing) * CGFloat(index) , y: .zero)
            let segmentPath = UIBezierPath(rect: .init(origin: origin, size: segmentSize))
            beizerPath.append(segmentPath)
        }

        let backgroundMask = CAShapeLayer()
        backgroundMask.path = beizerPath.cgPath
        layer.mask = backgroundMask

        let progressWidth = (segmentWidth + spacing) * CGFloat(currentIndex)

        let progressRect = CGRect(origin: .zero, size: .init(width: progressWidth, height: rect.height))
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = progressColor.cgColor
        layer.addSublayer(progressLayer)
    }

    private func animate() {
        let segmentWidth = (bounds.width - spacing * CGFloat(segmentCount - 1)) / CGFloat(max(segmentCount, 1))
        let progressWidth = (segmentWidth + spacing) * CGFloat(currentIndex)
        
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.fromValue = progressLayer.frame.width
        animation.toValue = progressWidth
        animation.duration = 0.2
        
        progressLayer.frame.size = .init(width: progressWidth, height: progressLayer.frame.height)
        progressLayer.add(animation, forKey: "progressAnimation")
    }
}
