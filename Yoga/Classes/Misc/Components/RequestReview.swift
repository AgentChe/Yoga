//
//  RequestReview.swift
//  Soccer
//
//  Created by Андрей Чернышев on 10.11.2022.
//

import StoreKit

final class RequestReview {
    static func request() {
        guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else {
            return
        }

        DispatchQueue.main.async {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
