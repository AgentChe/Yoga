//
//  WorkoutTrainingViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import UIKit
import RxSwift
import RxCocoa

class WorkoutTrainingViewController: UIViewController {
    lazy var mainView = WorkoutTrainingView()
    
    private let viewModel: WorkoutTrainingViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var lifeCyrcle = WorkoutTrainingLifeCyrcle()
    
    private let didFinish: ((WorkoutTraining) -> Void)
    
    private lazy var didStartStepRelay = PublishRelay<Void>()

    private init(customerWorkoutId: Int, didFinish: @escaping ((WorkoutTraining) -> Void)) {
        viewModel = .init(customerWorkoutId: customerWorkoutId)
        self.didFinish = didFinish
        
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
        
        AmplitudeManager.shared
            .logEvent(name: "Timer Screen")
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        Observable
            .merge(
                mainView.closeButton.rx.tap
                    .asObservable()
                    .do(onNext: {
                        AmplitudeManager.shared
                            .logEvent(name: "Timer Tap", parameters: ["what": "exit"])
                    }),
                mainView.menuView.finishButton.rx.tap
                    .asObservable()
                    .do(onNext: {
                        AmplitudeManager.shared
                            .logEvent(name: "Timer Tap", parameters: ["what": "finish"])
                    })
            )
            .withLatestFrom(viewModel.currentAndNextExercise)
            .bind(to: Binder(self) { base, tuple in
                base.cancelTraining(exersiseId: tuple.current.id)
            })
            .disposed(by: disposeBag)
        
        viewModel.didFinishExersise
            .asObservable()
            .mapToVoid()
            .asSignal(onErrorSignalWith: .never())
            .do(onNext: {
                AmplitudeManager.shared
                    .logEvent(name: "Timer Tap", parameters: ["what": "next"])
            })
            .emit(to: viewModel.didTapNext)
            .disposed(by: disposeBag)
        
        mainView.menuView.previosButton.rx.tap
            .asSignal()
            .do(onNext: {
                AmplitudeManager.shared
                    .logEvent(name: "Timer Tap", parameters: ["what": "back"])
            })
            .emit(to: viewModel.didTapPrevios)
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.exercises
            .drive(with: mainView) {
                $0.collectionView.setup(elements: $1)
                $0.progressView.segmentCount = $1.count
            }
            .disposed(by: disposeBag)
        
        viewModel.currentIndex
            .drive(with: mainView) { base, index in
                base.collectionView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: true)
                base.progressView.currentIndex = index + 1
            }
            .disposed(by: disposeBag)
        
        viewModel.route
            .emit(to: Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        mainView.menuView.nextButton.rx.tap
            .withLatestFrom(viewModel.currentAndNextExercise.asObservable())
            .bind(with: self) { base, tuple in
                base.lifeCyrcle.stopTraining(exersiseId: tuple.current.id)
            }
            .disposed(by: disposeBag)
        
        didStartStepRelay
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { base, step in
                base.viewModel.currentAndNextExercise
                    .asObservable()
            }
            .bind(to: Binder(self) { base, value in
                base.mainView.setup(current: value.current, next: value.next)
                base.lifeCyrcle.startTrainig()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .currentAndNextExercise
            .asObservable()
            .take(1)
            .mapToVoid()
            .bind(to: Binder(lifeCyrcle) { base, void in
                base.start()
            })
            .disposed(by: disposeBag)
        
        viewModel.currentIndex
            .withLatestFrom(viewModel.exercises) { $0 == $1.count - 1 }
            .drive(with: mainView.menuView) {
                $0.finishButton.isHidden = !$1
                $0.instructionButton.isHidden = $1
                $0.nextContainerView.isHidden = $1
            }
            .disposed(by: disposeBag)
        
        viewModel.menuState
            .drive(with: mainView.menuView) { view, state in
                switch state {
                case .last:
                    view.nextButton.isHidden = true
                    view.previosButton.isHidden = false
                case .middle:
                    view.nextButton.isHidden = false
                    view.previosButton.isHidden = false
                case .first:
                    view.previosButton.isHidden = true
                    view.nextButton.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        mainView.menuView.playPauseButton.rx.tap
            .bind(to: Binder(self) { base, void in
                switch base.mainView.menuView.playPauseButton.stateCode {
                case .pause:
                    AmplitudeManager.shared
                        .logEvent(name: "Timer Tap", parameters: ["what": "play"])
                    
                    base.lifeCyrcle.continueTraining()
                case .play:
                    AmplitudeManager.shared
                        .logEvent(name: "Timer Tap", parameters: ["what": "pause"])
                    
                    base.lifeCyrcle.pauseTraining()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.menuView.instructionButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.openInstruction()
            })
            .disposed(by: disposeBag)
        
        mainView.instructionView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.hideInstruction()
            })
            .disposed(by: disposeBag)
        
        workoutTrainingPrepare()
        lifeCyrcle.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

extension WorkoutTrainingViewController {
    static func make(customerWorkoutId: Int, didFinish: @escaping ((WorkoutTraining) -> Void)) -> WorkoutTrainingViewController {
        let vc = WorkoutTrainingViewController(customerWorkoutId: customerWorkoutId, didFinish: didFinish)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: WorkoutTrainingLifeCyrcleDelegate
extension WorkoutTrainingViewController: WorkoutTrainingLifeCyrcleDelegate {
    func workoutTrainingPrepare() {
        mainView.closeButton.isHidden = true
        mainView.pausedLabel.isHidden = true
        mainView.trainingTickLabel.isHidden = true
        mainView.setup(prepared: "")
        mainView.setup(prepareTick: "")
        mainView.setup(trainingTick: "")
        mainView.menu(hidden: true, animated: false)
        mainView.instruction(hidden: true, animated: false)
    }
    
    func workoutTrainingReadyIn(seconds: Int) {
        let string = String(format: "0:0%i", seconds)
        mainView.setup(prepareTick: string)
    }
    
    func workoutTrainingPrepared() {
        mainView.setup(prepared: "DrillTraining.Go".localized)
    }
    
    func workoutTrainingDidStart() {
        mainView.closeButton.isHidden = false
        mainView.pausedLabel.isHidden = true
        mainView.trainingTickLabel.isHidden = false
        mainView.menu(hidden: false)
        mainView.setup(prepared: "")
        mainView.setup(prepareTick: "")
        mainView.menuView.playPauseButton.stateCode = .play
    }
    
    func workoutTrainingStartStep() {
        didStartStepRelay.accept(())
    }
    
    func workoutTrainingTick(seconds: Int) {
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        let string = String(format: "%02d:%02d", mins, secs)
        
        mainView.setup(trainingTick: string)
        
        mainView.menuView.playPauseButton.stateCode = .play
    }
    
    func workoutTrainigPaused() {
        mainView.pausedLabel.isHidden = false
        mainView.menuView.playPauseButton.stateCode = .pause
    }
    
    func workoutTrainingStopped(totalSeconds: Int, exersiseId: Int) {
        viewModel.didFinishExersise.accept((totalSeconds, exersiseId))
    }
    
    func workoutTrainingFinish(totalSeconds: Int, exersiseId: Int) {
        mainView.instruction(hidden: true, animated: false)
        mainView.menu(hidden: true, animated: false)
        
        mainView.pausedLabel.isHidden = false
        mainView.menuView.playPauseButton.stateCode = .pause
        
        viewModel.didFinishWorkout.accept((totalSeconds, exersiseId))
    }
}

// MARK: Private
private extension WorkoutTrainingViewController {
    func route(_ route: WorkoutTrainingViewModel.Route) {
        switch route {
        case .finished(let workoutTraining):
            dismiss(animated: true) { [weak self] in
                self?.didFinish(workoutTraining)
            }
        }
    }
    
    func cancelTraining(exersiseId: Int) {
        lifeCyrcle.pauseTraining()
        
        mainView.instruction(hidden: true, animated: false)
        mainView.menu(hidden: true, animated: false)
        
        let vc = WorkoutTrainingQuitViewController.make { [weak self] finish in
            if finish {
                self?.lifeCyrcle.finishWorkout(exersiseId: exersiseId)
            } else {
                self?.lifeCyrcle.continueTraining()
            }
        }
        present(vc, animated: false)
    }
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func openInstruction() {
        AmplitudeManager.shared
            .logEvent(name: "Timer Tap", parameters: ["what": "instruction"])
        
        mainView.menu(hidden: true) { [weak self] in
            self?.mainView.instruction(hidden: false) {
                self?.lifeCyrcle.pauseTraining()
            }
        }
    }
    
    func hideInstruction() {
        mainView.instruction(hidden: true) { [weak self] in
            self?.mainView.menu(hidden: false) {
                self?.lifeCyrcle.continueTraining()
            }
        }
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
