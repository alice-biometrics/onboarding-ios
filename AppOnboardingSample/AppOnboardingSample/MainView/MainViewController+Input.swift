//  MainViewController+Input.swift
//  Copyright © 2019 ALiCE. All rights reserved.

import UIKit
import Foundation

extension MainViewController: UITextFieldDelegate, UITextViewDelegate {
    func configureInputs() {
        emailText.layer.cornerRadius = 20
        actionButton.layer.cornerRadius = 20
        actionButton.titleLabel!.text = "START"
        self.emailText.isHidden = true
        self.topTextView.isHidden = true
        self.middleTextView.isHidden = true
        self.emailView.isHidden = true
        self.emailText.delegate = self
        self.textFieldTop.delegate = self
        self.textFieldMiddle.delegate = self
        self.view.bringSubviewToFront(self.emailText)
        self.view.bringSubviewToFront(self.emailView)
        self.emailText.keyboardType = UIKeyboardType.emailAddress
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view,
                                                              action: #selector(UIView.endEditing(_:))))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        updateMailTextField()
    }
    func getEmail() -> String {
            return self.emailText.text!
    }
    func getFirstName() -> String {
        if self.typeFirstName && self.typeLastName {
             return self.textFieldTop.text!
        } else if self.typeFirstName && !self.typeLastName {
            return self.textFieldMiddle.text!
        }
        return ""
    }
    func getLastName() -> String {
        if self.typeLastName {
            return self.textFieldMiddle.text ?? ""
        } else {
            return ""
        }
    }
    func configureActionButtonToLogIn() {
        isStart = false
        self.emailText.isHidden = false
        self.emailView.isHidden = false
        self.middleTextView.isHidden = true
        self.topTextView.isHidden = true
        if self.typeFirstName && self.typeLastName {
            self.middleTextView.isHidden = false
            self.textFieldMiddle.placeholder = "Please, type your last name."
            self.topTextView.isHidden = false
            self.textFieldTop.placeholder = "Please, type your first name."
        } else if self.typeFirstName {
             self.middleTextView.isHidden = false
             self.textFieldMiddle.placeholder = "Please, type your first name."
        } else if self.typeLastName {
            self.middleTextView.isHidden = false
            self.textFieldMiddle.placeholder = "Please, type your last name."
        }
        self.actionButton.setTitle("LOG IN", for: .normal)
        actionButton.layer.cornerRadius = 20
        updateMailTextField()
    }
    func updateMailTextField() {
        if randomName {
            let device = UIDevice.current.name.components(separatedBy: .whitespaces).joined().prefix(20)
            let username = "\(device)_\(String.random(length: 5))"
            self.emailText.text = "\(username)@alicebiometrics.com"
        } else {
            self.emailText.text = nil
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension String {
    static func random(length: Int = 20) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray: [Character] = Array(charactersString)
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        return string
    }
}
