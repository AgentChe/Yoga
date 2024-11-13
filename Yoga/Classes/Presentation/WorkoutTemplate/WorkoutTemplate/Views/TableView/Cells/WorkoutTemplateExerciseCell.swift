//
//  WorkoutTemplateExerciseCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import UIKit
import Kingfisher

final class WorkoutTemplateExerciseCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    lazy var labelsContainer = makeLabelsContainer()
    lazy var nameLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(20.8.scale)
        .textAlignment(.left)
    private lazy var subTitleAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(18.2.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension WorkoutTemplateExerciseCell {
    func setup(element: WorkoutExercise) {
        pictureView.kf.setImage(with: element.image)
        
        nameLabel.attributedText = element.name.attributed(with: nameAttrs)
        subTitleLabel.attributedText = element.subTitle.attributed(with: subTitleAttrs)
    }
}

// MARK: Private
private extension WorkoutTemplateExerciseCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension WorkoutTemplateExerciseCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 90.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 90.scale),
            pictureView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            labelsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 122.scale),
            labelsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56.scale),
            labelsContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 32.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 32.scale),
            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WorkoutTemplateExerciseCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.mono200.withAlphaComponent(0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabelsContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "WorkoutTemplate.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
