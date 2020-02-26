//  MainViewController+LogIn.swift
//  Copyright © 2019 ALiCE. All rights reserved.

import Foundation
import AliceOnboarding
import Result

enum LogInError: Error {
    case getTokenError(_ message: String)
    case createUserError(_ message: String)
    case invalidEmail
}

extension MainViewController {
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func logInWithSandbox(email: String,
                          firstName: String? = "",
                          lastName: String? = "",
                          completion: @escaping ((Result<String, LogInError>) -> Void)) {
        if isValidEmail(email: email) {
            let sandboxManager = SandboxManager(sandboxToken: self.sandboxToken)
            sandboxManager.getUser(email: email) { resultGetUser in
                if case .success = resultGetUser {
                    sandboxManager.getUserToken(email: email) { resultGetUserToken in
                        switch resultGetUserToken {
                        case .success(let userToken):
                            completion(.success(userToken))
                        case .failure(let error):
                            completion(.failure(.getTokenError(self.logInErrorFromSandboxError(sandboxError: error))))
                        }
                    }
                } else {
                    let userInfo = UserInfo(email: email,
                                            firstName: firstName!,
                                            lastName: lastName!)
                    sandboxManager.createUser(userInfo: userInfo) { resultCreateUser in
                        switch resultCreateUser {
                        case .success:
                            sandboxManager.getUserToken(email: email) { resultGetUserToken in
                                switch resultGetUserToken {
                                case .success(let userToken):
                                    completion(.success(userToken))
                                case .failure(let error):
                                    completion(.failure(.getTokenError(
                                        self.logInErrorFromSandboxError(sandboxError: error))))
                                }
                            }
                        case .failure(let error):
                            completion(.failure(.createUserError(self.logInErrorFromSandboxError(sandboxError: error))))
                        }
                    }
                }
            }
        } else {
            completion(.failure(.invalidEmail))
        }
    }
    func logInErrorFromSandboxError(sandboxError: SandboxError) -> String {
        switch sandboxError {
        case .invalidSandboxToken(let statusCode, let message):
            return "\(statusCode): \(message)"
        case .userNotFound:
            return "User not Found Error"
        case .clientError(let statusCode, let message):
            return "\(statusCode): \(message)"
        case .serverError(let statusCode, let message):
            return "\(statusCode): \(message)"
        case .connectionError:
            return "Connection Error"
        case .encodingError:
            return "Encoding Error"
        case .unknownError:
            return "Unknown Error"
        @unknown default:
            return "Unknown Error"
        }
    }
}
