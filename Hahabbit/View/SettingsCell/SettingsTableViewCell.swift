//
//  SettingsTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
