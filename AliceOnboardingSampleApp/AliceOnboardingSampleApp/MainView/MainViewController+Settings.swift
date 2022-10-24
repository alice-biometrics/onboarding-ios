//  MainViewController+Settings.swift
//  Copyright © 2019 Alice. All rights reserved.

import Foundation
import AliceOnboarding

extension MainViewController {
    func configureSettings() {
        let isConfigured = UserDefaults.standard.bool(forKey: "IsConfigured")
        if !isConfigured {
            UserDefaults.standard.set(true, forKey: SettingsBundleHelper.Keys.AddSelfie)
            UserDefaults.standard.set(true, forKey: SettingsBundleHelper.Keys.SelectCountry)
            UserDefaults.standard.set(true, forKey: SettingsBundleHelper.Keys.AddDocumentSpanishIdcard)
            UserDefaults.standard.set(true, forKey: SettingsBundleHelper.Keys.AddDocumentSpanishDriverLicense)
            UserDefaults.standard.set(true, forKey: SettingsBundleHelper.Keys.AddDocumentPassport)
            UserDefaults.standard.set(true, forKey: "IsConfigured")
        }

        registerSettingsBundle()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.defaultsChanged),
                                               name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
    }
    func registerSettingsBundle() {
        let appDefaults = [String: AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    @objc func defaultsChanged() {
        self.useOnboardingCommands = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.UseOnboardingCommands)
        
        self.addSelfie = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.AddSelfie)
        self.selectCountry = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.SelectCountry)

        self.addDocumentSpanishIdcard = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.AddDocumentSpanishIdcard)
        self.addDocumentSpanishDriverLicense = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.AddDocumentSpanishDriverLicense)
        self.addDocumentSpanishResidencePermit = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.AddDocumentSpanishResidencePermit)
        self.addDocumentPassport = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.AddDocumentPassport)

        self.experimentalEnvironment = UserDefaults.standard.bool(
            forKey: SettingsBundleHelper.Keys.ExoerimentalEnvironment)
        if self.experimentalEnvironment {
            Onboarding.setEnvironment(.staging)
            self.sandboxToken = UserDefaults.standard.string(
                forKey: SettingsBundleHelper.Keys.SandboxTokenExperimentalEnvironment) ?? ""
        } else {
            Onboarding.setEnvironment(.production)
            self.sandboxToken = UserDefaults.standard.string(forKey: SettingsBundleHelper.Keys.SandboxToken) ?? ""
        }
        self.typeFirstName = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.TypeFirstName)
        self.typeLastName = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.TypeLastName)
        self.randomName = UserDefaults.standard.bool(forKey: SettingsBundleHelper.Keys.RandomMail)
        if !isStart {
            configureActionButtonToLogIn()
        }
    }
}

class SettingsBundleHelper {
    struct Keys {
        static let Reset = "RESET_APP_KEY" // Not used for now.
        static let BuildVersion = "build_preference"
        static let AppVersion = "version_preference"
        static let OnboardingVersion = "onboarding_framework_version"
        static let UseOnboardingCommands = "UseOnboardingCommandsKey"
        static let AddSelfie = "AddSelfieKey"
        static let SelectCountry = "SelectCountryKey"
        static let AddDocumentSpanishIdcard = "AddDocumentSpanishIdcardKey"
        static let AddDocumentPassport = "AddDocumentPassportKey"
        static let AddDocumentSpanishDriverLicense = "AddDocumentSpanishDriverLicenseKey"
        static let AddDocumentSpanishResidencePermit = "AddDocumentSpanishResidencePermitKey"
        static let SandboxToken = "SandboxTokenKey"
        static let ExoerimentalEnvironment = "ExoerimentalEnvironmentKey"
        static let SandboxTokenExperimentalEnvironment = "SandboxTokenExperimentalEnvironmentKey"
        static let TypeFirstName = "TypeFirstNameKey"
        static let TypeLastName = "TypeLastNameKey"
        static let RandomMail = "RandomMailKey"
    }
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: Keys.Reset) {
            UserDefaults.standard.set(false, forKey: Keys.Reset)
            let appDomain: String? = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            // reset userDefaults..
            // CoreDataDataModel().deleteAllData()
            // delete all other user data here..
        }
    }
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        UserDefaults.standard.set(version, forKey: Keys.AppVersion)
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        UserDefaults.standard.set(build, forKey: Keys.BuildVersion)
        UserDefaults.standard.set(Onboarding.version(), forKey: Keys.OnboardingVersion)
    }
}
