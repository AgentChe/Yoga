//
//  ProfileDetailsViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class ProfileDetailsViewController: UIViewController {
    lazy var mainView = ProfileDetailsView()
    
    private let viewModel: ProfileDetailsViewModel = .init()
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.elements
            .drive(with: mainView.tableView) { $0.setup(elements: $1) }
            .disposed(by: disposeBag)
        
        viewModel.route
            .emit(with: self) { $0.route($1) }
            .disposed(by: disposeBag)
        
        mainView.tableView.selectedCellModel
            .bind(to: viewModel.selectedCellModel)
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension ProfileDetailsViewController {
    func route(_ route: ProfileDetailsViewModel.Route) {
        switch route {
        case .skillLevel(let level):
            let vc = ProfileEditViewController.make(skillLevel: level)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .trainingDays(let weekSchedule):
            let vc = ProfileEditViewController.make(weekSchedule: weekSchedule)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .focusZone(let zones, let gender):
            let vc = ProfileEditViewController.make(focusZones: zones, gender: gender)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .goals(let array):
            let vc = ProfileEditViewController.make(goals: array)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .open(let url):
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension ProfileDetailsViewController {
    static func make() -> ProfileDetailsViewController {
        let vc = ProfileDetailsViewController()
        vc.navigationItem.title = "Profile.MyProfile".localized
        return vc
    }
}
