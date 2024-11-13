//
//  PaygateViewControllerDelegate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

enum PaygateViewControllerResult {
    case bied, restored, cancelled
}

protocol PaygateViewControllerDelegate: AnyObject {
    func paygateDidClosed(with result: PaygateViewControllerResult)
}
