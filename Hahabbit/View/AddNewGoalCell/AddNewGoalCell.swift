//
//  AddNewGoalCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AddNewGoalCell: UITableViewCell {
  @IBOutlet weak var mainImage: UIImageView! {
    didSet {
      mainImage.layer.cornerRadius = 10
    }
  }
  @IBOutlet weak var label: UILabel!
}
