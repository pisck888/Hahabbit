//
//  LoginViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/28.
//

import UIKit
import AuthenticationServices
import WebKit
import CryptoKit
import FirebaseAuth
import Lottie

class LoginViewController: UIViewController {

  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var upImageBackView: UIView!
  @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var loginButtonBackView: UIView!
  @IBOutlet weak var signInWithAppleButton: MyAuthorizationAppleIDButton!
  @IBOutlet var privacyPolicyView: UIView!
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var catReading: AnimationView!

  // Unhashed nonce.
  private var currentNonce: String?

  lazy var blurView: UIView = {
    let blurView = UIView(frame: view.frame)
    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    return blurView
  }()
  let animationView = AnimationView(name: "catReading")

  override func viewDidLoad() {
    super.viewDidLoad()
    webView.navigationDelegate = self
    setupLoginView()
    skipButton.isHidden = true
  }


  func setupLoginView() {
    catReading.play()
    catReading.loopMode = .loop
    catReading.contentMode = .scaleAspectFit

    signInWithAppleButton.layer.cornerRadius = 10
    signInWithAppleButton.clipsToBounds = true

    loginButtonBackView.layer.cornerRadius = 10
    loginButtonBackView.layer.shadowOffset = CGSize(width: 2, height: 2)
    loginButtonBackView.layer.shadowOpacity = 0.5
    loginButtonBackView.layer.shadowRadius = 2
    loginButtonBackView.layer.shadowColor = UIColor.black.cgColor

    upImageBackView.layer.cornerRadius = 10
    upImageBackView.layer.shadowOffset = CGSize(width: 2, height: 2)
    upImageBackView.layer.shadowOpacity = 0.5
    upImageBackView.layer.shadowRadius = 2
    upImageBackView.layer.shadowColor = UIColor.black.cgColor
  }

  func showPrivacyPolicyView() {
    // set popView
    blurView.alpha = 0.4
    privacyPolicyView.layer.cornerRadius = 10
    privacyPolicyView.clipsToBounds = true
    privacyPolicyView.frame.size = CGSize(width: view.frame.width * 0.9, height: view.frame.height * 0.8)
    privacyPolicyView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    privacyPolicyView.center = view.center
    closeButton.layer.cornerRadius = closeButton.frame.width / 2

    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveLinear
    ) {
      self.privacyPolicyView.transform = .identity
    }

    if let url = URL(string: "https://www.privacypolicies.com/live/eadbc4ac-181f-4ad9-8395-935c0b6da7d0") {
      webView.load(URLRequest(url: url))
      view.addSubview(blurView)
      view.addSubview(privacyPolicyView)
      loadingIndicatorView.startAnimating()
    }
  }

  @IBAction func pressAppleButton(_ sender: MyAuthorizationAppleIDButton) {
    startSignInWithAppleFlow()
  }

  @IBAction func pressPrivacyPolicyButton(_ sender: UIButton) {
    showPrivacyPolicyView()
  }

  @IBAction func pressCloseButton(_ sender: UIButton) {
    blurView.removeFromSuperview()
    privacyPolicyView.removeFromSuperview()
  }

  @available(iOS 13, *)
  func startSignInWithAppleFlow() {

    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName]

    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  @available(iOS 13, *)
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()
    return hashString
  }

  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    return result
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(
        withProviderID: "apple.com",
        idToken: idTokenString,
        rawNonce: nonce
      )

      Auth.auth().signIn(with: credential) { authResult, error in
        if error != nil {
          print(error?.localizedDescription as Any)
          return
        }
        if let user = authResult?.user {
          print(user.uid)
          // Create an account in your system.
          UserManager.shared.signInUser(
            id: user.uid,
            name: String(user.displayName ?? "使用者")
          )
          self.performSegue(withIdentifier: MySegue.toMainPage, sender: nil)
        }
      }
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

extension LoginViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    loadingIndicatorView.stopAnimating()
  }
}
