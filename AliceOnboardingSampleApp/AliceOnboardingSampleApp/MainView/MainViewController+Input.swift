//  MainViewController+Input.swift
//  Copyright © 2019 Alice. All rights reserved.

import UIKit
import Foundation

extension MainViewController: UITextFieldDelegate, UITextViewDelegate {
    func configureInputs() {
        emailText.layer.cornerRadius = 20
        actionButton.layer.cornerRadius = 20
        actionButton.titleLabel!.text = "START"
        self.emailText.isHidden = true
        self.emailView.isHidden = true
        self.emailText.delegate = self
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
    func configureActionButtonToLogIn() {
        isStart = false
        self.emailText.isHidden = false
        self.emailView.isHidden = false

        self.actionButton.setTitle("LOG IN", for: .normal)
        actionButton.layer.cornerRadius = 20
        updateMailTextField()
    }
    func updateMailTextField() {
        if randomMail {
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
