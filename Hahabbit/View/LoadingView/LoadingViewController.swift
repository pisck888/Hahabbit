//
//  LoadingViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/6.
//

import UIKit
import JGProgressHUD

class LoadingViewController: UIViewController {

  let hud = JGProgressHUD()

  override func viewDidLoad() {
    super.viewDidLoad()
    hud.textLabel.text = "上傳中..."
    hud.show(in: self.view)
  }
}
