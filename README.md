# onboarding-ios 
[![pods](https://cocoapod-badges.herokuapp.com/v/AliceOnboarding/badge.png)](https://github.com/alice-biometrics/onboarding-ios)
[![platform](https://cocoapod-badges.herokuapp.com/p/AliceOnboarding/badge.png)](https://github.com/alice-biometrics/onboarding-ios)
[![license](https://cocoapod-badges.herokuapp.com/l/AliceOnboarding/badge.png)](https://github.com/alice-biometrics/onboarding-ios)
[![doc](https://img.shields.io/badge/doc-onboarding-51CB56)](https://docs.alicebiometrics.com/onboarding/) 
[![doc-ios](https://img.shields.io/badge/doc-ios-51CB56)](https://docs.alicebiometrics.com/onboarding/sdk/ios/)

ALiCE Onboarding iOS component allows the automatic capture of documents and video selfie of the user in real time from the camera of your device. It also simplifies the communication with the onboarding API to facilitate rapid integration and development. It manages the onboarding flow configuration: requested documents and order.

The main features are:

- Automatic capture of documents and video selfie of the user in real time from the camera of your device.
- Communication with the onboarding API to facilitate rapid integration and development.
- Manage the onboarding flow configuration: requested documents and order.

## Installation :computer:

**Using Cocoapods**

The AliceOnboarding component is available on Cocoapods. Add AliceOnboarding to your projects adding to your Podfile the following code:

```
pod 'AliceOnboarding'
```

## Usage :wave:

### Import the library


```swift
import AliceOnboarding
```

### Configuration

You can configure the onboarding flow with the following code:

```swift
let userToken = "<ADD-YOUR-USER-TOKEN-HERE>"

let config = OnboardingConfig.builder()
  .withUserToken(userToken)
  .withAddSelfieStage()
  .withAddDocumentStage(ofType: .idcard, issuingCountry: "ESP")
  .withAddDocumentStage(ofType: .driverlicense, issuingCountry: "ESP")
```

Where `userToken` is used to secure requests made by the users on their mobile devices or web clients. You should obtain it from your Backend.


### Using ALiCE Onboarding on Production

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

### Using ALiCE Onboarding on Trial

On the other hand, if you want to test the technology without integrate it with your backend, you can use our Sandbox Service. This service associates a user mail with the ALiCE Onboarding `user_id`. You can create an user and obtain its `USER_TOKEN` already linked with the email.

For more information about the Sandbox, please check the following [doc](https://docs.alicebiometrics.com/onboarding/access.html#using-alice-onboarding-sandbox).

Use the `aliceonboarding.logInWithSandbox` function to ease the integration.

```js
let sandboxToken = "<ADD-YOUR-SANDBOX-TOKEN-HERE>"
let userInfo = new onboarding.UserInfo(email)

aliceonboarding.logInWithSandbox(sandboxToken, userInfo)
  .then(userToken => {
    // Obtain previously configured OnboardingConfig object
    let config = getOnboardingConfig(userToken, appSettings);
    
    function onSuccess(userInfo) {console.log("onSuccess: " + userInfo)}
    function onFailure(error) {console.log("onFailure: " + error)}
    function onCancel() { console.log("onCancel")}
        
    new aliceonboarding.Onboarding("#alice-onboarding-mount", config).run(onSuccess, onFailure, onCancel);
  })
  .catch(err => {
    console.error(err);
  });
```

Where `sandboxToken` is a temporal token for testing the technology in a development/testing environment. 

An `email` is required to associate it to an ALiCE Onboarding `user_id`. You can also add some additional information from your user.

```swift
let userInfo = new UserInfo(
  email,
  firstName,
  lastName
)
```

## Demo

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

Add your `SANDBOX_TOKEN` credentials in `Settings -> CREDENTIALS -> Sandbox Token` 

## Customisation


Please, visit the doc.

https://docs.alicebiometrics.com/onboarding/sdk/ios/customisation.html


## Documentation :page_facing_up:

For more information about ALiCE Onboarding:  https://docs.alicebiometrics.com/onboarding/

## Contact :mailbox_with_mail:

support@alicebiometrics.com

