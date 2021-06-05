//
//  LoginViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/28.
//

import UIKit
import AuthenticationServices
import SwiftKeychainWrapper
import WebKit

class LoginViewController: UIViewController {

  @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var signInButtonView: UIView!
  @IBOutlet var popupView: UIView!
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var closeButton: UIButton!

  lazy var blurView: UIView = {

    let blurView = UIView(frame: view.frame)

    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

    return blurView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    webView.navigationDelegate = self
    setupLoginView()
  }

  func setupLoginView() {
    let signInButton = ASAuthorizationAppleIDButton()
    signInButton.addTarget(self, action: #selector(pressSignInButton), for: .touchUpInside)
    signInButton.frame = signInButtonView.bounds
    signInButtonView.addSubview(signInButton)
  }

  func showPopupView() {
    // set popView
    blurView.alpha = 0.4
    popupView.layer.cornerRadius = 10
    popupView.clipsToBounds = true
    popupView.frame.size = CGSize(width: view.frame.width * 0.9, height: view.frame.height * 0.8)
    popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    popupView.center = view.center
    closeButton.layer.cornerRadius = closeButton.frame.width / 2

    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0.7,
                   options: .curveLinear) {
      self.popupView.transform = .identity
    }

    if let url = URL(string: "https://www.privacypolicies.com/live/eadbc4ac-181f-4ad9-8395-935c0b6da7d0") {
      webView.load(URLRequest(url: url))
      view.addSubview(blurView)
      view.addSubview(popupView)
    }
  }

  @IBAction func pressPrivacyPolicyButton(_ sender: UIButton) {
    showPopupView()
  }
  
  @IBAction func pressCloseButton(_ sender: UIButton) {
    blurView.removeFromSuperview()
    popupView.removeFromSuperview()
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

extension LoginViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    loadingIndicatorView.startAnimating()
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    loadingIndicatorView.stopAnimating()
  }
}
