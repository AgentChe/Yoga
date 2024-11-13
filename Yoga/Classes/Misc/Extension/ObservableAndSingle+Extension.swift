//
//  ObservableAndSingleExtension.swift
//  Soccer
//
//  Created by Андрей Чернышев on 29.03.2022.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        map { _ -> Void in
            Void()
        }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    func mapToVoid() -> Single<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
