//
//  LoginViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/28.
//

import UIKit
import AuthenticationServices
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

  @IBOutlet weak var signInButtonView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLoginView()
  }

  func setupLoginView() {
    let signInButton = ASAuthorizationAppleIDButton()
    signInButton.addTarget(self, action: #selector(pressSignInButton), for: .touchUpInside)
    signInButton.frame = signInButtonView.bounds
    signInButtonView.addSubview(signInButton)
  }

  @objc func pressSignInButton() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]

    let controller = ASAuthorizationController(authorizationRequests: [request])

    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:

      // Create an account in your system.
      UserManager.shared.signInUser(
        id: appleIDCredential.user,
        name: String(appleIDCredential.fullName?.givenName ?? "使用者"),
        email: String(appleIDCredential.email ?? "")
      )

      // For the purpose of this demo app, store the `userIdentifier` in the keychain.
      let saveSuccessful = KeychainWrapper.standard.set(appleIDCredential.user, forKey: "Hahabbit")

      print("user: \(appleIDCredential.user)", "get keychain \(saveSuccessful)")
      performSegue(withIdentifier: "SegueToMainPage", sender: nil)
    default:
      print("Complete with default case")
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    switch error {
    case ASAuthorizationError.canceled:
      break
    case ASAuthorizationError.failed:
      break
    case ASAuthorizationError.invalidResponse:
      break
    case ASAuthorizationError.notHandled:
      break
    case ASAuthorizationError.unknown:
      break
    default:
      break
    }
    print("didCompleteWithError: \(error.localizedDescription)")
  }

}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    view.window!
  }
}

extension UIViewController {
  func showLoginController() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
      loginViewController.modalPresentationStyle = .fullScreen
      self.present(loginViewController, animated: false, completion: nil)
    }
  }
}
