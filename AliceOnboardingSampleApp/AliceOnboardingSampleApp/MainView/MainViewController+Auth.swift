//  MainViewController+TrialAuthenticator.swift
//  Copyright © 2020 Alice. All rights reserved.

import Foundation
import AliceOnboarding


enum AuthenticationMode {
    case trial
    case production
}

class MyBackendAuthenticator : Authenticator {
    
    func execute(completion: @escaping Response<String, AuthenticationError>){
        
        // Add here your code to retrieve the user token from your backend
        
        let userToken = "fakeUserToken"
        completion(.success(userToken))
    }
}

extension MainViewController {
    
    func getAuthenticator(_ authenticationMode: AuthenticationMode) -> Authenticator{
        switch authenticationMode {
        case .trial:
            return TrialAuthenticator(trialToken: self.trialToken, userInfo: self.userInfo!)
        case .production:
            return MyBackendAuthenticator()
        }
    }
}
