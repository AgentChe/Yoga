//
//  NetworkError.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2022.
//

struct NetworkError: Error {
    enum Code {
        case serverNotAvailable
        case logical(String)
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
