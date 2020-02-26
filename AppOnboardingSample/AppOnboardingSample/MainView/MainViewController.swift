//  MainViewController.swift
//  Copyright © 2019 ALiCE. All rights reserved.

import UIKit
import TransitionButton
import AliceOnboarding

class MainViewController: UIViewController {
    // Input properties
    @IBOutlet var actionButton: TransitionButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var textFieldMiddle: UITextField!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet var iconViewTop: UIImageView!
    @IBOutlet var iconViewMiddle: UIImageView!
    @IBOutlet var topTextView: UIView!
    @IBOutlet var middleTextView: UIView!
    @IBOutlet var emailView: UIView!
    // Settings properties
    // It determines if the app runs on Onboarding mode or using OnboardingCommand class.
    var useOnboardingCommands: Bool = false
    // It determines if the OnboardingConfig uses a pre-configured flow or let the user to add their document
        
    var addSelfie: Bool = true
    var selectCountry: Bool = true
    var addDocumentSpanishIdcard: Bool = true
    var addDocumentSpanishDriverLicense: Bool = true
    var addDocumentSpanishResidencePermit: Bool = false
    var addDocumentPassport: Bool = true
    var experimentalEnvironment: Bool = false
    var sandboxToken: String = ""
    var typeFirstName: Bool = false
    var typeLastName: Bool = false
    var randomName: Bool = false
    var isStart: Bool = true
    var userInfo: UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        printOnboardingInfo()
        configureInputs()
        configureSettings()
    }
    @IBAction func settingsAction(_ sender: Any) {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func buttonAction(_ button: TransitionButton) {
        self.view.endEditing(true)
        if isStart {
            configureActionButtonToLogIn()
        } else {
            let email = self.getEmail()
            let firstName = self.getFirstName()
            let lastName = self.getLastName()
            button.spinnerColor = UIColor(red: 1.0, green: 120/255, blue: 0, alpha: 1)
            button.startAnimation()
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async(execute: {
                
                self.userInfo = UserInfo(email: email,
                                        firstName: firstName,
                                        lastName: lastName)
                
                let authenticator = self.getAuthenticator(.trial)
                
                // Please, for production environments use .production authentication mode
                // Find in MainViewController+Auth an example
                // let authenticator = self.getAuthenticator(.production)
                
                authenticator.execute { result in
                    switch result {
                    case .success(let userToken):
                        button.stopAnimation(animationStyle: .normal, completion: {
                            if self.useOnboardingCommands {
                                self.aliceOnboardingCommand(userToken: userToken)
                            } else {
                                self.aliceOnboarding(userToken: userToken,
                                                     selectCountry: self.selectCountry)
                            }
                            self.actionButton.layer.cornerRadius = 20
                        })
                    case .failure(let error):
                        button.stopAnimation(animationStyle: .shake, completion: {
                            showAlert(viewController: self,
                                      title: "Authenticator Error",
                                      message: "\(error):")
                            self.actionButton.layer.cornerRadius = 20
                        })
                    }
                }
            })
        }
    }
}
