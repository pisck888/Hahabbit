//
//  AddNewGoalCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AddNewHabitTableViewCell: UITableViewCell {
  @IBOutlet weak var backView: UIView! {
    didSet {
      backView.layer.cornerRadius = 10
      backView.layer.shadowOffset = CGSize(width: 2, height: 2)
      backView.layer.shadowOpacity = 0.5
      backView.layer.shadowRadius = 2
      backView.layer.shadowColor = UIColor.black.cgColor
    }
  }
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainImage: UIImageView! {
    didSet {
      mainImage.layer.cornerRadius = 10
    }
  }
}
