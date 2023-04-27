//  OnboardingCommandViewController.swift
//  Copyright © 2019 Alice. All rights reserved.

import UIKit
import AliceOnboarding
import SwiftyJSON

class OnboardingCommandViewController: UIViewController {
    var userToken: String?
    var email: String?
    var onboardingCommands: OnboardingCommands?
    @IBOutlet weak var addFaceButton: UIButton!
    @IBOutlet weak var addDocumentButton: UIButton!
    @IBOutlet weak var getUserStatusButton: UIButton!
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var getDocumentSupportedButton: UIButton!
    @IBOutlet weak var headerText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsApparecence()
        headerText.text = "Onboarding Commands [\(email ?? "-")]"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onboardingCommands = OnboardingCommands(self, userToken: userToken!) { result in
            
        }
    }
    @IBAction func commandAddSelfie(_ sender: Any) {
        self.onboardingCommands!.addSelfie { result in
            switch result {
            case .success:
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "Added the selfie successfully to Alice Onboarding")
            case .failure(let error):
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "Error adding the selfie (\(error))")
            case .cancel:
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "User has cancelled the command")
            case .dismissButton:
                break
            }
        }
    }
    @IBAction func commandAddDocument(_ sender: Any) {
        let documentType = DocumentType.driverlicense
        let documentIssuingCountry = "ESP"
        let documentSide = DocumentSide.front
        self.onboardingCommands!.createDocument(
            type: documentType,
            issuingCountry: documentIssuingCountry) { resultCreateDocument in
                switch resultCreateDocument {
                case .success(let onboardingResponse):
                    let documentId = onboardingResponse.content as? String
                    self.onboardingCommands!.addDocument(
                        documentId: documentId!,
                        type: documentType,
                        issuingCountry: documentIssuingCountry,
                        side: documentSide) { resultAddDocument in
                            switch resultAddDocument {
                            case .success:
                                let message =
                                """
                                Added a document (\(documentType) - \(documentIssuingCountry) - \(documentSide))
                                successfully to Alice Onboarding"
                                """
                                showAlert(viewController: self,
                                          title: "OnboardingCommand",
                                          message: message)
                            case .failure(let error):
                                showAlert(viewController: self,
                                          title: "OnboardingCommand",
                                          message: "Error adding the document (\(error))")
                            case .cancel:
                                showAlert(viewController: self,
                                          title: "OnboardingCommand",
                                          message: "User has cancelled the command")
                            case .dismissButton:
                                break
                            }
                    }
                case .failure(let error):
                    showAlert(viewController: self,
                              title: "OnboardingCommand",
                              message: "Error creating the document (\(error))")
                case .cancel:
                    showAlert(viewController: self,
                              title: "OnboardingCommand",
                              message: "User has cancelled the command")
                case .dismissButton:
                    break
                }
        }
    }
    @IBAction func commandGetUserStatus(_ sender: Any) {
        self.onboardingCommands!.getUserStatus { result in
            switch result {
            case .success(let onboardingResponse):
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "UserStatus:\n \(onboardingResponse.content ?? "")")
            case .failure(let error):
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "Error getting User Status(\(error))")
            case .cancel:
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "User has cancelled the command")
            case .dismissButton:
                break
            }
        }
    }
    @IBAction func commandAuthenticate(_ sender: Any) {
        self.onboardingCommands!.getUserStatus { result in
            switch result {
            case .success(let onboardingResponse):
                do {
                    let userStatusString = (onboardingResponse.content! as? String)!
                    let userStatusJSON =  try JSON(data: userStatusString.data(using: .utf8)!)
                    let isUserAuthorized =  userStatusJSON["user"]["authorized"].boolValue
                    let email =  try JSON(data: userStatusString.data(using: .utf8)!)["user"]["email"].rawString()
                    if isUserAuthorized {
                        self.onboardingCommands!.authenticate { result in
                            switch result {
                            case .success(let onboardingResponse):
                                let authenticationId = onboardingResponse.content ?? ""
                                let message =
                                """
                                Authenticate on Alice Onboarding.
                                Your backend have the response of your authentication
                                (use authenticationId: \(authenticationId))
                                """
                                showAlert(viewController: self,
                                          title: "OnboardingCommand",
                                          message: message)
                            case .failure(let error):
                                showAlert(viewController: self,
                                          title: "OnboardingCommand",
                                          message: "Error authenticating (\(error))")
                            case .cancel:
                                showAlert(viewController: self,
                                          title: "OnboardingCommand",
                                          message: "User has cancelled the command")
                            case .dismissButton:
                                break
                            }
                        }
                    } else {
                        let message =
                        """
                        User with email \(email!) is not authorized yet.
                        Get access with your backend or using Alice Dashboard
                        """
                        showAlert(viewController: self,
                                  title: "OnboardingCommand",
                                  message: message)
                    }
                } catch {
                    showAlert(viewController: self,
                              title: "OnboardingCommand",
                              message: "Error decoding (JSON) User Status")
                }
            case .failure(let error):
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "Error getting User Status (\(error))")
            case .cancel:
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "User has cancelled the command")
            case .dismissButton:
                break
            }
        }
    }
    @IBAction func commandGetDocumentsSupported(_ sender: Any) {
        self.onboardingCommands!.getDocumentsSupported { result in
            switch result {
            case .success(let onboardingResponse):
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "DocumentsSupported:\n \(onboardingResponse.content ?? "")")
            case .failure(let error):
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "Error getting User Status(\(error))")
            case .cancel:
                showAlert(viewController: self,
                          title: "OnboardingCommand",
                          message: "User has cancelled the command")
            case .dismissButton:
                break
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func setButtonsApparecence() {
        let cornerRadius = CGFloat(20)
        let backgroundColor = UIColor(red: 0/255, green: 63/255, blue: 162/255, alpha: 1).cgColor
        addFaceButton.layer.cornerRadius = cornerRadius
        addFaceButton.layer.backgroundColor = backgroundColor
        addDocumentButton.layer.cornerRadius = cornerRadius
        addDocumentButton.layer.backgroundColor = backgroundColor
        getUserStatusButton.layer.cornerRadius = cornerRadius
        getUserStatusButton.layer.backgroundColor = backgroundColor
        authenticateButton.layer.cornerRadius = cornerRadius
        authenticateButton.layer.backgroundColor = backgroundColor
        getDocumentSupportedButton.layer.cornerRadius = cornerRadius
        getDocumentSupportedButton.layer.backgroundColor = backgroundColor
        backButton.layer.cornerRadius = cornerRadius
    }
}
