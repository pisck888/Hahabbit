//
//  MyTabBarViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/14.
//

import UIKit

class MyTabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
  }
}

extension MyTabBarViewController: UITabBarControllerDelegate {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    ImpactFeedbackGenerator.impactOccurred()
  }
}
