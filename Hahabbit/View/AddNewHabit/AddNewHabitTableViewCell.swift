//
//  AddNewGoalCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AddNewHabitTableViewCell: UITableViewCell {

  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainImage: UIImageView!

  override func awakeFromNib() {

    super.awakeFromNib()

    self.selectionStyle = .none

    mainImage.layer.cornerRadius = 10

    backView.setCornerRadiusAndShadow()
  }

  func setup(title: String, image: String) {
    titleLabel.text = title
    mainImage.image = UIImage(named: image)
  }

}
