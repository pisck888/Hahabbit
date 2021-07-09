//
//  LaunchPageViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/7.
//

import UIKit
import FirebaseAuth

class LaunchPageViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    imageView.center = view.center
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
      self.imageView.shake()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [unowned self] in
      self.presentNextVC()
    }
  }

  func presentNextVC() {
    if let user = Auth.auth().currentUser {
      print("You are sign in as \(user.uid)")
      UserManager.shared.currentUser = user.uid
      performSegue(withIdentifier: MySegue.toMainPage, sender: nil)
    } else {
      performSegue(withIdentifier: MySegue.toLoginPage, sender: nil)
    }
  }
}
