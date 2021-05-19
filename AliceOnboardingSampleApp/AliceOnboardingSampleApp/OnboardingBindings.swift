//  OnboardingBindings.swift
//  Copyright © 2019 Alice. All rights reserved.

import Foundation
import AliceOnboarding

/**
 Onboarding Binding proposal (YAML)
 
 - Parameter viewController: Parent ViewController
 - Parameter userToken: User Token obtained from your Backend (Sandbox when developing)
 - Parameter onboardingConfigYAML: Path of a YAML-based configuration file
 - Parameter completion: This handler will give you call back inside block when response is received.
 
 On completion, it returns a OnboardingResult

 */
public func onboardingBindingFromYAML(_ viewController: UIViewController,
                                      userToken: String,
                                      onboardingConfigYAML: String,
                                      completion: @escaping ((OnboardingResult) -> Void)) {
    
    var config: OnboardingConfig
    config = try! OnboardingConfig.fromYAML(onboardingConfigYAML, withUserToken: userToken)
    
    let onboarding = Onboarding(viewController, config: config)
    onboarding.run(completion: completion)
}

/**
Onboarding Binding proposal  (Dictionary)

- Parameter viewController: Parent ViewController
- Parameter userToken: User Token obtained from your Backend (Sandbox when developing)
- Parameter onboardingConfigDictionary: Configuration in a dictionary (Useful to dynamically configure onboarding flow)
- Parameter completion: This handler will give you call back inside block when response is received.

On completion, it returns a OnboardingResult

 ```
 let onboardingConfigDictionary = [
     "stages": [
         ["stage": "addSelfie"],
         ["stage": "addDocument", "type": "idcard"],
         ["stage": "addDocument", "type": "driverlicense", "issuingCountry": "ESP"],
         ["stage": "addDocument", "type": "passport"]
     ],
     "localization": ["language": "en"],
     "appearance": [
         "primaryColor": ["red": 0.129, "blue": 0.478, "green":  0.121, "alpha": 1],
         "secondaryColor": ["red": 0.509, "blue": 0.509, "green": 0.509, "alpha": 1],
         "uncheckedItemsColor": ["red": 0.47, "blue": 0.47, "green": 0.47, "alpha": 1],
         "fontRegular": "System Thin",
         "fontBold": "System Light"
     ]
     ] as [String : Any]
 onboardingBindingFromDictionary(self,
                                 userToken: userToken,
                                 onboardingConfigDictionary: onboardingConfigDictionary) { result in
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
 ```

*/
public func onboardingBindingFromDictionary(_ viewController: UIViewController,
                                            userToken: String,
                                            onboardingConfigDictionary: [String: Any],
                                            completion: @escaping ((OnboardingResult) -> Void)) {
    var config: OnboardingConfig
    config = try! OnboardingConfig.fromDictionary(onboardingConfigDictionary, withUserToken: userToken)
    
    let onboarding = Onboarding(viewController, config: config)
    onboarding.run(completion: completion)
}
