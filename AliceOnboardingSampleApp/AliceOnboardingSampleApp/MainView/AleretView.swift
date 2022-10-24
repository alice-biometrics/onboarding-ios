import Foundation
import UIKit


public func showAlert(viewController: UIViewController, title: String, message: String? = nil,  completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style {
        case .default:
            guard completion != nil else {
                return
            }
            completion!()
        case .cancel:
            break
        case .destructive:
            break
        @unknown default:
            return
        }
    }))
    viewController.present(alert, animated: true, completion: nil)
}
