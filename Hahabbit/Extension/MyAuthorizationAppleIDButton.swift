//
//  MyAuthorizationAppleIDButton.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/10.
//

import UIKit
import AuthenticationServices

@IBDesignable
class MyAuthorizationAppleIDButton: UIButton {

  private var authorizationButton: ASAuthorizationAppleIDButton!

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override public func draw(_ rect: CGRect) {
    super.draw(rect)

    // Create ASAuthorizationAppleIDButton
    authorizationButton = ASAuthorizationAppleIDButton(
      authorizationButtonType: .default,
      authorizationButtonStyle: .black
    )

    // Set selector for touch up inside event so that can forward the event to MyAuthorizationAppleIDButton
    authorizationButton.addTarget(self, action: #selector(authorizationAppleIDButtonTapped(_:)), for: .touchUpInside)

    // Show authorizationButton
    addSubview(authorizationButton)

    // Use auto layout to make authorizationButton follow the MyAuthorizationAppleIDButton's dimension
    authorizationButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      authorizationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
      authorizationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
      authorizationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
      authorizationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
    ])
  }

  @objc func authorizationAppleIDButtonTapped(_ sender: Any) {
    // Forward the touch up inside event to MyAuthorizationAppleIDButton
    sendActions(for: .touchUpInside)
  }

}
