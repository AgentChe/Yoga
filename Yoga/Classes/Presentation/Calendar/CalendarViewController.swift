//
//  CalendarViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 21.04.2023.
//

import UIKit
import RxSwift
import Foundation
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    lazy var mainView = CalendarView()
    
    private let viewModel: CalendarViewModel
    private lazy var disposeBag = DisposeBag()
    
    private init(schedulerType: CalendarViewModel.SchedulerType) {
        viewModel = .init(schedulerType: schedulerType)
        
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
        
        viewModel.plan
            .drive(with: self) {
                $0.mainView.calendarCollection.setup(elements: $1)
            }
            .disposed(by: disposeBag)
        
        viewModel.scheduleResult
            .emit(with: self) { base, _ in
                base.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.addButton.rx.tap
            .bind(to: viewModel.didTapAdd)
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.calendarCollection.selectedDate
            .bind(to: viewModel.selectedDate)
            .disposed(by: disposeBag)
        
        mainView.calendarCollection.scrollToDate(.init(), animateScroll: false) { [weak self] in
            
            guard let self = self else { return }
            
            self.mainView.calendarCollection.selectDates([.init()])
            
            if let today = self.mainView.calendarCollection.indexPathsForSelectedItems?.first {
                
                self.mainView.calendarCollection.scrollToItem(at: today, at: .centeredVertically, animated: false)
            }
        }
    }
}

// MARK: Make
extension CalendarViewController {
    static func make(schedulerType: CalendarViewModel.SchedulerType) -> CalendarViewController {
        let vc = CalendarViewController(schedulerType: schedulerType)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CalendarViewController {
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
