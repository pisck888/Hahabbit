//
//  MainPageTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {

  @IBOutlet weak var backView: UIView!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backView.layer.cornerRadius = 10
    backView.layer.borderWidth = 1
    backView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
  }

  @IBAction func pressCheckButton(_ sender: UIButton) {
    sender.isSelected.toggle()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
