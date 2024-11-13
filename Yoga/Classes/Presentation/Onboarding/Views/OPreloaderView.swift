//
//  OPreloaderView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 21.10.2022.
//

import UIKit
import RxSwift

final class OPreloaderView: OSlideView {
    weak var vc: UIViewController?
    
    lazy var progressView = makeProgressView()
    lazy var textLabel = makeLabel()
    
    private lazy var titleAttrs = makeTitleAttrs()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var animationCompleted = false
    private lazy var requestCompleted = false
    
    private var timer: Timer?
    
    private let combineData: OnboardingCombineData
    
    init(step: OnboardingView.Step, combineData: OnboardingCombineData) {
        self.combineData = combineData
        
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Loading Screen")
        
        calculatePercent()
        request()
        
        RequestReview.request()
    }
}

// MARK: Private
private extension OPreloaderView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    func request() {
        guard let data = combineData.combineData() else {
            return
        }
        
        func source() -> Single<Void> {
            profileManager
                .set(skillLevelId: data.skillLevel.id,
                     weekSchedule: data.weekSchedule,
                     drillsIds: data.drillCategories,
                     focusZonesIds: data.focusZones.map { $0.id },
                     gender: data.gender)
        }
        
        func error(err: Error) -> Observable<Void> {
            open(error: err)
        }
        
        observableRetrySingle
            .retry(source: { source() },
                   trigger: { error(err: $0) })
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, void in
                base.requestCompleted = true
                base.checkCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    func calculatePercent() {
        let duration = Double(7)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            
            self.progressView.setup(percent: percent)
            self.updateText(percent: percent)
            
            if seconds >= duration {
                timer.invalidate()
                
                self.calculatePercentFinish()
            }
        }
    }
    
    func updateText(percent: Int) {
        let string: String
        if percent <= 25 {
            string = "Onboarding.Preloader.Text1".localized
        } else if percent <= 50 {
            string = "Onboarding.Preloader.Text2".localized
        } else if percent <= 75 {
            string = "Onboarding.Preloader.Text3".localized
        } else {
            string = "Onboarding.Preloader.Text4".localized
        }
        textLabel.attributedText = string.attributed(with: titleAttrs)
    }
    
    func calculatePercentFinish() {
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.animationCompleted = true
            self?.checkCompleted()
        }
    }
    
    func checkCompleted() {
        guard animationCompleted && requestCompleted else {
            return
        }
        
        onNext()
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
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}

// MARK: Make constraints
private extension OPreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 31.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OPreloaderView {
    func makeProgressView() -> OCircleProgressView {
        let view = OCircleProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
    }
}
