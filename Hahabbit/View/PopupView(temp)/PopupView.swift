//
//  PopupView.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/31.
//

import Foundation
import UIKit

protocol PopupViewDelegate: AnyObject {
  func closePopupView()
}

class PopupView: UIView {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var mainImage: UIImageView!

  weak var delegate: PopupViewDelegate?

  @IBAction func pressCloseButton(_ sender: UIButton) {
    self.removeFromSuperview()
    delegate?.closePopupView()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    closeButton.layer.cornerRadius = closeButton.frame.width / 2
  }
}
