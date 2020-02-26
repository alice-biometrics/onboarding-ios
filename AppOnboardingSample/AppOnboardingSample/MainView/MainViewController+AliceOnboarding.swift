//  MainViewController+Onboarding.swift
//  Copyright © 2019 ALiCE. All rights reserved.

import Foundation
import AliceOnboarding


extension MainViewController {
    func printOnboardingInfo() {
        print(Onboarding.info())
    }
    
    func getConfig(userToken: String, selectCountry: Bool) -> OnboardingConfig{
        var config: OnboardingConfig
        let appearanceConfig = AppearanceConfig()
       
        config = OnboardingConfig.builder()
            .withUserToken(userToken)
            .withAppearanceConfig(appearanceConfig: appearanceConfig)
            //.withCustomLocalization(inBundle: Bundle.main, language: "en")
       
        if addSelfie {
            config = try! config.withAddSelfieStage()
        }
        if(selectCountry) {
            if addDocumentSpanishIdcard {
                config = try! config.withAddDocumentStage(ofType: .idcard)
            }
            if addDocumentSpanishDriverLicense {
                config = try! config.withAddDocumentStage(ofType: .driverlicense)
            }
            if addDocumentSpanishResidencePermit {
                config = try! config.withAddDocumentStage(ofType: .residencepermit)
            }
            if addDocumentPassport {
                config = try! config.withAddDocumentStage(ofType: .passport)
            }
        } else {
            if addDocumentSpanishIdcard {
               config = try! config.withAddDocumentStage(ofType: .idcard, issuingCountry: "ESP")
            }
            if addDocumentSpanishDriverLicense {
                config = try! config.withAddDocumentStage(ofType: .driverlicense, issuingCountry: "ESP")
            }
            if addDocumentSpanishResidencePermit {
                config = try! config.withAddDocumentStage(ofType: .residencepermit, issuingCountry: "ESP")
            }
            if addDocumentPassport {
                config = try! config.withAddDocumentStage(ofType: .passport)
            }
        }
        return config
    }
    func aliceOnboarding(userToken: String, selectCountry: Bool) {
        let config = getConfig(userToken: userToken, selectCountry: selectCountry)
        let onboarding = Onboarding(self, config: config)
        onboarding.run { result in
            switch result {
            case let .success(userStatus):
                print("userStatus: \(String(describing: userStatus))")
                let userId =  userStatus["user_id"]
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let viewController =
                    storyBoard.instantiateViewController(withIdentifier: "showResultViewController")
                        as? ShowResultViewController else {
                            return
                }
                viewController.userId = userId.stringValue
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            case let .failure(error):
                showAlert(viewController: self, title: "Onboarding", message: "Error: \(error.localizedDescription)")
            case .cancel:
                return
            }
        }
    }
    func aliceOnboardingCommand(userToken: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController =
            storyBoard.instantiateViewController(withIdentifier: "onboardingCommandViewController")
                as? OnboardingCommandViewController else {
                    return
        }
        viewController.userToken = userToken
        viewController.email = emailText.text
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
