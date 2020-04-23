# onboarding-ios <img src="https://github.com/alice-biometrics/custom-emojis/blob/master/images/ios.png" width="30"> [![pods](https://cocoapod-badges.herokuapp.com/v/AliceOnboarding/badge.png)](https://github.com/alice-biometrics/onboarding-ios) [![license](https://cocoapod-badges.herokuapp.com/l/AliceOnboarding/badge.png)](https://github.com/alice-biometrics/onboarding-ios) [![doc](https://img.shields.io/badge/doc-onboarding-51CB56)](https://docs.alicebiometrics.com/onboarding/) [![doc-ios](https://img.shields.io/badge/doc-ios-51CB56)](https://docs.alicebiometrics.com/onboarding/sdk/ios/)

<img src="https://github.com/alice-biometrics/custom-emojis/blob/master/images/alice_header.png" width=auto>

ALiCE Onboarding iOS component allows the automatic capture of documents and video selfie of the user in real time from the camera of your device. It also simplifies the communication with the onboarding API to facilitate rapid integration and development. It manages the onboarding flow configuration: requested documents and order.

The main features are:

- Automatic capture of documents and video selfie of the user in real time from the camera of your device.
- Communication with the onboarding API to facilitate rapid integration and development.
- Manage the onboarding flow configuration: requested documents and order.

## Table of Contents
- [Installation :computer:](#installation-computer)
- [Getting Started :chart_with_upwards_trend:](#getting-started-chart_with_upwards_trend)
  * [Import the library](#import-the-library)
  * [Permissions](#permissions)
  * [Onboarding](#onboarding)
  * [Onboarding with Commands](#onboarding-with-commands)
- [Authentication :closed_lock_with_key:](#authentication-closed_lock_with_key)
  * [Trial](#trial)
  * [Production](#production)
- [Demo :rocket:](#demo-rocket)
- [Customisation :gear:](#customisation-gear)
- [Documentation :page_facing_up:](#documentation-page_facing_up)
- [Contact :mailbox_with_mail:](#contact-mailbox_with_mail)


## Installation :computer:

**Using Cocoapods**

The AliceOnboarding component is available on Cocoapods. Add AliceOnboarding to your projects adding to your `Podfile` the following code:

```
pod 'AliceOnboarding'
```

Install with:

```console
pod repo update
pod install
```

## Getting Started :chart_with_upwards_trend:

You can integrate the onboarding process in two different ways: using a pre-configured flow, through the `Onboarding` class, or creating a manual flow, through the `OnboardingCommands` class.

In the first case, you simply need to indicate to the SDK the flow you want: number and type of documents, order, etc. From this configuration, the SDK takes control and allows you to perform the entire onboarding process autonomously without having to worry about managing ALiCE Onboarding API calls. This is the fastest and easiest way to integrate the onboarding process in your application.

In the second case, no flow is specified. The onboarding process is completely free, allowing your application to manage the beginning and end of it, as well as the capture and upload of the different documents to the API. This case is indicated for an expert level of configuration, allowing you to split the onboarding process into different stages and add other tasks related to your customer flow (e.g. a form to be filled in by the user).

### Import the library

```swift
import AliceOnboarding
```

### Permissions 

* Camera Permission is required. 

For more info, please check Apple [Documentation]( https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/requesting_authorization_for_media_capture_on_ios).

### Onboarding

Check detailed doc about `Onboarding` class [here](https://docs.alicebiometrics.com/onboarding/sdk/ios/Classes/Onboarding.html).

##### Configuration

You can configure the onboarding flow with the following code:

```swift
let userToken = "<ADD-YOUR-USER-TOKEN-HERE>"

let config = OnboardingConfig.builder()
  .withUserToken(userToken)
  .withAddSelfieStage()
  .withAddDocumentStage(ofType: .idcard, issuingCountry: "ESP")
  .withAddDocumentStage(ofType: .driverlicense, issuingCountry: "ESP")
```

Where `userToken` is used to secure requests made by the users on their mobile devices or web clients. You should obtain it from your Backend (see [Authentication :closed_lock_with_key:](#authentication-closed_lock_with_key)).


##### Run ALiCE Onboarding

Once you configured the ALiCE Onboarding Flow, you can run the process with:

```swift
let onboarding = Onboarding(self, config: config)
onboarding.run { result in
    switch result {
    case let .success(userStatus):
        print("userStatus: \(String(describing: userStatus))")
    case let .failure(error):
        print("failure: \(error.localizedDescription)")
    case .cancel:
        print("User has cancelled the onboarding")
    }
}
```

### Onboarding with Commands

Check detailed doc about `OnboardingCommands` class [here](https://docs.alicebiometrics.com/onboarding/sdk/ios/Classes/OnboardingCommands.html).
 
You can configure and run specific actions with the class `OnboardingCommands`. 
This mode allows you to use the following commands:
* `addSelfie`: Presents a Selfie Capturer and upload this info to ALiCE Onboarding.
* `createDocument`: Creates a document (`DocumentType`, `DocumentIssuingCountry`). It returns a `DocumentId`.
* `addDocument`: Add document Side. It requires as input a valid `DocumentId` and `DocumentSide`.
* `getUserStatus`: Returns information about the User.
* `authenticate`: Presents a Selfie Capturer and verify the identity of the enrolled user. User must be authorized to use this command.
* `getDocumentsSupported`: Returns a map with information about supported documents in ALiCE Onboarding



First of all, you have to configure an `OnboardingCommand` instance:

```swift
let onboardingCommands = OnboardingCommands(self, userToken: userToken!)
```

Once you configured the `OnboardingCommands`, you can run the selected process with:

##### Run Selfie Capturer

```swift
onboardingCommands!.addSelfie { result in
  switch result {
  case .success:
      showAlert(viewController: self,
                title: "OnboardingCommand",
                message: "Added the selfie successfully to ALiCE Onboarding")
  case .failure(let error):
      showAlert(viewController: self,
                title: "OnboardingCommand",
                message: "Error adding the selfie (\(error))")
  case .cancel:
      showAlert(viewController: self,
                title: "OnboardingCommand",
                message: "User has cancelled the command")
  }
}
```

##### Run Document Capturer

```swift
let documentType = DocumentType.driverlicense
let documentIssuingCountry = "ESP"
let documentSide = DocumentSide.front
onboardingCommands!.createDocument(
    type: documentType,
    issuingCountry: documentIssuingCountry) { resultCreateDocument in
        switch resultCreateDocument {
        case .success(let onboardingResponse):
            let documentId = onboardingResponse.content as? String
            onboardingCommands!.addDocument(
                documentId: documentId!,
                type: documentType,
                issuingCountry: documentIssuingCountry,
                side: documentSide) { resultAddDocument in
                    switch resultAddDocument {
                    case .success:
                        let message =
                        """
                        Added a document (\(documentType) - \(documentIssuingCountry) - \(documentSide))
                        successfully to ALiCE Onboarding"
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
        }
}
```

Check an example of this in the [AppOnboardingSample](https://github.com/alice-biometrics/onboarding-ios/blob/master/AppOnboardingSample/AppOnboardingSample/OnboardingCommandViewController.swift) application.


## Authentication :closed_lock_with_key:

How can we get the `userToken` to start testing ALiCE Onboarding technology?

`AliceOnboarding` can be used with two differnet authentication modes:

* Trial (Using ALiCE Onboarding Sandbox): Recommended only in the early stages of integration.
    - Pros: This mode does not need backend integration.
    - Cons: Security compromises. It must be used only for develpment and testing.
* Production (Using your Backend): In a production deployment we strongly recommend to use your backend to obtain required TOKENS.
    - Pros: Full security level. Only your backend is able to do critical operations.
    - Cons: Needs some integration in your backend.

### Trial

If you want to test the technology without integrate it with your backend, you can use our Sandbox Service. This service associates a user mail with the ALiCE Onboarding `user_id`. You can create a user and obtain his `USER_TOKEN` already linked with the email.

Use the `SandboxAuthenticator` class to ease the integration.

```swift
let sandboxToken = "<ADD-YOUR-SANDBOX-TOKEN-HERE>"
let userInfo = UserInfo(email: email, // required
                        firstName: firstName, // optional 
                        lastName: lastName)  // optional 
                        
let authenticator = SandboxAuthenticator(sandboxToken: sandboxToken, userInfo: userInfo)

authenticator.execute { result in
    switch result {
    case .success(let userToken):
       // Configure ALiCE Onboarding with the OnboardingConfig
       // Then Run the ALiCE Onboarding Flow
    case .failure(let error):
       // Inform the user about Authentication Errors
    }
}
```

The `sandboxToken` is a temporal token for testing the technology in a development/testing environment. 

An `email` parameter in `UserInfo` is required to associate it to an ALiCE Onboarding `user_id`. You can also add some additional information from your user as `firstName` and `lastName`.

See the authentication options [here](AppOnboardingSample/AppOnboardingSample/MainView/MainViewController+Auth.swift)

For more information about the Sandbox, please check the following [doc](https://docs.alicebiometrics.com/onboarding/access.html#using-alice-onboarding-sandbox).

### Production

On the other hand, for a production environments we strongly recommend to use your backend to obtain the required `USER_TOKEN`.

You can implement the `Authenticator` protocol available in the `AliceOnboarding` framework.

```swift
class MyBackendAuthenticator : Authenticator {
    
    func execute(completion: @escaping Response<String, AuthenticationError>){
        
        // Add here your code to retrieve the user token from your backend
        
        let userToken = "fakeUserToken"
        completion(.success(userToken))
    }
}
```

In a very similar way to the authentication available with the sandbox:

```swift
                        
let authenticator = MyBackendAuthenticator()

authenticator.execute { result in
    switch result {
    case .success(let userToken):
       // Configure ALiCE Onboarding with the OnboardingConfig
       // Then Run the ALiCE Onboarding Flow
    case .failure(let error):
       // Inform the user about Authentication Errors
    }
}
```


## Demo :rocket:

Check our iOS demo in this repo (`AppOnboardingSample` folder). 

Intall cocoapods dependencies with:

```console
cd AppOnboardingSample
pod install
```

Open the Xcode workspace

```console
open AppOnboardingSample.xcworkspace
```

#### App

Add your `SANDBOX_TOKEN` credentials in `Settings -> CREDENTIALS -> Sandbox Token` 

<img src="images/app_settings.jpg" width="200">



## Customisation :gear:


Please, visit the doc.

https://docs.alicebiometrics.com/onboarding/sdk/ios/customisation.html


## Documentation :page_facing_up:

For more information about ALiCE Onboarding:  https://docs.alicebiometrics.com/onboarding/

## Contact :mailbox_with_mail:

support@alicebiometrics.com

