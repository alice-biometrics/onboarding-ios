//  MainViewController.swift
//  Copyright © 2019 Alice. All rights reserved.

import UIKit
import TransitionButton
import AliceOnboarding

class MainViewController: UIViewController {
    // Input properties
    @IBOutlet var actionButton: TransitionButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet var emailView: UIView!
    // Settings properties
    // It determines if the app runs on Onboarding mode or using OnboardingCommand class.
    var useOnboardingCommands: Bool = false
    // It determines if the OnboardingConfig uses a pre-configured flow or let the user to add their document
        
    var addSelfie: Bool = true
    var selectCountry: Bool = true
    var addDocumentIdcard: Bool = true
    var addDocumentDriverLicense: Bool = true
    var addDocumentResidencePermit: Bool = false
    var addDocumentPassport: Bool = true
    var randomMail: Bool = false

    var appEnvironment: Environment = .sandbox
    var trialToken: String = ""
    var isStart: Bool = true
    var userInfo: UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        printOnboardingInfo()
        configureInputs()
        configureSettings()
        customize()
    }
    
    func customize() {
        //To customize icons
        //In the assets there are examples of the icons that we use in which you can see the size
        OnboardingAppearence.statusView.selfieIcon = UIImage(named: "holding-cell")
        OnboardingAppearence.statusView.idCardIcon = UIImage(named: "document")
        
        //To change the color of the icon background
        OnboardingAppearence.statusView.iconBackgroundColorActive = UIColor.white
        
        
        OnboardingAppearence.statusView.continueButtonColor = UIColor.green
        OnboardingAppearence.statusView.contiueButtonTextColor = UIColor.red
        
        //To use the original color in the progressHUB use progressBlurEffectStyle with regular
        OnboardingAppearence.selfieCaptureView.progressHUBBackgroundColor = UIColor.green
        OnboardingAppearence.selfieCaptureView.progressBlurEffectStyle = .regular
        OnboardingAppearence.selfieCaptureView.progressHUBTextColor = .white
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
            button.spinnerColor = UIColor(red: 123/255, green: 255/255, blue: 251/255, alpha: 1)
            button.startAnimation()
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async(execute: {
                
                self.userInfo = UserInfo(email: email)
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
