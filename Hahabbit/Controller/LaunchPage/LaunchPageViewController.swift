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
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.imageView.shake()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.presentNextVC()
    }
  }

  func presentNextVC() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let user = Auth.auth().currentUser {
      print("You are sign in as \(user.uid)")
      UserManager.shared.currentUser = user.uid
      let controller = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
      controller.modalTransitionStyle = .crossDissolve
      controller.modalPresentationStyle = .fullScreen
      self.present(controller, animated: true, completion: nil)
    } else {
      let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
      controller.modalTransitionStyle = .crossDissolve
      controller.modalPresentationStyle = .fullScreen
      self.present(controller, animated: true, completion: nil)
    }

  }
}
