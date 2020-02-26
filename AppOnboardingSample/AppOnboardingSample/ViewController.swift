//
//  ViewController.swift
//  AppOnboardingSample
//
//  Created by Artur Costa-Pazo on 10/07/2019.
//  Copyright © 2019 ALiCE. All rights reserved.
//

import UIKit
import Onboarding

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var aliceOnboarding: AliceOnboarding?
    @IBOutlet weak var captureFace: UIButton!
    @IBOutlet weak var captureDocument: UIButton!
    @IBOutlet weak var captureCustomDocument: UIButton!
    @IBOutlet weak var showStatus: UIButton!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.emailText.keyboardType = UIKeyboardType.emailAddress
        let cornerRadius = CGFloat(20)
        let bordeWidth = CGFloat(1)
        let borderColor = UIColor(white: 1, alpha: 1).cgColor
        let backgroundColor = UIColor(red: 235/255, green: 210/255, blue: 47/255, alpha: 1).cgColor
        setButtonsApparecence(hidden: true,
                              cornerRadius: cornerRadius,
                              bordeWidth: bordeWidth,
                              borderColor: borderColor,
                              backgroundColor: backgroundColor)
    }
    func createUser(email: String) {
        let backend = BackendSample(url: "https://pre.alicebiometrics.com/onboarding-backoffice")
        backend.createUser(mail: email) { result in
            if case .error( _) = result {
                self.showAlert(title: "Auth problem",
                               message: "Please, contact Pablo and he can help you")
                return
            }
            backend.startOnboarding(mail: email) { result in
                if case .error( _) = result {
                    self.showAlert(title: "Auth problem",
                                   message: "Please, contact pdago@gradiant.org and he can help you")
                    return
            }
            if case .success(let userToken) = result {
                guard let userTokenStr = userToken as? String else {
                    return
                }
                let config = AliceOnboardingConfig.builder()
                    .withUserToken(userTokenStr)
                self.aliceOnboarding = AliceOnboarding(self, config: config)
                }
            }
          self.setButtonsHidden(hidden: false)
        }
    }
    @IBAction func captureDocument(_ sender: Any) {
        let documentConfig = DocumentConfig(type: .idcard, side: .back, country: .spain)

        aliceOnboarding!.createDocument(completion: { result in
             if case .success(let documentIdAny) = result {
                guard let documentId = documentIdAny as? String else {
                    return
                }
                self.aliceOnboarding!.addDocument(documentId: documentId, documentConfig: documentConfig) { _ in
                }
            }
       })
    }
    @IBAction func captureFace(_ sender: Any) {
        self.aliceOnboarding!.addFace { result in
            print(result)
        }
     }
    @IBAction func captureCustomDocument(_ sender: Any) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "configDocumentViewController")
            as? ConfigDocumentViewController else {
                return
        }
        viewController.completion = { result in
            if case .success(let documentConfigAny) = result {
                guard let documentConfig = documentConfigAny as? DocumentConfig else {
                    return
                }
                self.aliceOnboarding!.createDocument(completion: { result in
                if case .success(let documentIdAny) = result {
                    guard let documentId = documentIdAny as? String else {
                        return
                    }
                    self.aliceOnboarding!.addDocument(documentId: documentId,
                                                      documentConfig: documentConfig) { _ in
                  }
               }
            })
          }
        }
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func showStatus(_ sender: Any) {
        self.aliceOnboarding!.showStatus { result in
            print(result)
        }
    }
    /* Below method is inherited from UITextFieldDelegate,
     it will be invoked when text filed get focus and click return key. */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("TextField textFieldShouldReturn method triggered.")
        textField.endEditing(true)
        let mail = isValidEmail(emailStr: textField.text!)
        if mail {
            self.createUser(email: textField.text!)
        } else {
             showAlert(title: "Invalid email", message: "Please, try with a valid email.")
        }
        return true
    }
    /* Below method is inherited from UITextViewDelegate, it will be invoked when text view content is changed. */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            NSLog("TextView textView method triggered and the input text is '\n'.")
        }
        return true
    }
    /* Invoked when first edit the textfield control. */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NSLog("TextField textFieldDidBeginEditing method triggered.")
        // Clear the default text.
        textField.placeholder = "Your email"
    }
    /* Invoked when first edit the textview control. */
    func textViewDidBeginEditing(_ textView: UITextView) {
        NSLog("TextView textViewDidBeginEditing method triggered.")
        // Clear the default text.
        textView.text = nil
    }
    func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    func setButtonsApparecence(hidden: Bool,
                               cornerRadius: CGFloat,
                               bordeWidth: CGFloat,
                               borderColor: CGColor,
                               backgroundColor: CGColor) {
        captureFace.isHidden = true
        captureFace.layer.cornerRadius = cornerRadius
        captureFace.layer.borderWidth = bordeWidth
        captureFace.layer.borderColor = borderColor
        captureFace.layer.backgroundColor = backgroundColor
        captureDocument.isHidden = true
        captureDocument.layer.cornerRadius = cornerRadius
        captureDocument.layer.borderWidth = bordeWidth
        captureDocument.layer.borderColor = borderColor
        captureDocument.layer.backgroundColor = backgroundColor
        captureCustomDocument.isHidden = true
        captureCustomDocument.layer.cornerRadius = cornerRadius
        captureCustomDocument.layer.borderWidth = bordeWidth
        captureCustomDocument.layer.borderColor = borderColor
        captureCustomDocument.layer.backgroundColor = backgroundColor
    }
    func setButtonsHidden(hidden: Bool) {
        captureFace.isHidden = hidden
        captureDocument.isHidden = hidden
        captureCustomDocument.isHidden = hidden
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style {
        case .default:
        print("default")
        case .cancel:
        print("cancel")
        case .destructive:
        print("destructive")
        }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
