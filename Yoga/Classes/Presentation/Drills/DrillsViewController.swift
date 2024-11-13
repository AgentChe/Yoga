//
//  DrillsViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit
import RxSwift

final class DrillsViewController: UIViewController {
    lazy var mainView = DrillsView()
    
    private lazy var viewModel = DrillsViewModel(drillCategory: drillCategory)
    
    private lazy var disposeBag = DisposeBag()
    
    private let drillCategory: DrillCategory?
    
    private init(drillCategory: DrillCategory?) {
        self.drillCategory = drillCategory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension DrillsViewController {
    static func make(drillCategory: DrillCategory? = nil) -> DrillsViewController {
        let vc = DrillsViewController(drillCategory: drillCategory)
        vc.navigationItem.title = drillCategory?.name ?? "Home.TryDrills".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: DrillsTableDelegate
extension DrillsViewController: DrillsTableDelegate {
    func drillsTableDidTap(element: Drill) {
        let needPayment = element.paid ? !SessionManager().hasActiveSubscriptions() : false
        
        if needPayment {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            let vc = DrillTrainingInstructionViewController.make(drill: element)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: Private
private extension DrillsViewController {
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
