//
//  HomeWorkoutsCollectionCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.02.2023.
//

import UIKit
import Kingfisher

final class HomeWorkoutsCollectionCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var shadowView = makeShadowView()
    lazy var nameLabel = makeNameLabel()
    lazy var skillLevel = makeTagLabel()
    lazy var exercisesCountLabel = makeTagLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var tagAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.semiBold(size: 12.scale))
        .lineHeight(14.4.scale)
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension HomeWorkoutsCollectionCell {
    func setup(element: HomeWorkoutElement) {
        imageView.kf.setImage(with: element.workout.image)
        
        nameLabel.attributedText = element.workout.name.attributed(with: nameAttrs)
        skillLevel.attributedText = element.skillLevel.name.attributed(with: tagAttrs)
        
        let exercisesCount = String(format: "Home.ExercisesCount".localized, element.workout.exercisesCount)
        exercisesCountLabel.attributedText = exercisesCount.attributed(with: tagAttrs)
    }
}

// MARK: Private
private extension HomeWorkoutsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension HomeWorkoutsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 255.scale)
        ])
        
        NSLayoutConstraint.activate([
            skillLevel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            skillLevel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            exercisesCountLabel.leadingAnchor.constraint(equalTo: skillLevel.trailingAnchor, constant: 10.scale),
            exercisesCountLabel.centerYAnchor.constraint(equalTo: skillLevel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeWorkoutsCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeShadowView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(integralRed: 9, green: 9, blue: 9, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTagLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = Appearance.mono200.withAlphaComponent(0.2)
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
