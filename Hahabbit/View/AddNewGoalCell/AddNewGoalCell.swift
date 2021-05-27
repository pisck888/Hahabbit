//
//  AddNewGoalCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AddNewGoalCell: UITableViewCell {
  @IBOutlet weak var backView: UIView! {
    didSet {
      backView.layer.cornerRadius = 10
      backView.clipsToBounds = true
    }
  }
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainImage: UIImageView!
}
