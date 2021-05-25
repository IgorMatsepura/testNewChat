//
//  AuthError.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//
// Обработка различных ошибок и исключени возникающих при работе


import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case unknownError
    case serverError
    case cannotGetUserInfo
    case cannotUnwrapToModelUser
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in everything", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email is incorrect", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Pasword is short", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Not load info about User из FireStore", comment: "")
        case .cannotUnwrapToModelUser:
            return NSLocalizedString("Not converted ModelUser in  User", comment: "")
        }
    }
}

