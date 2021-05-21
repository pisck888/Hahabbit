//
//  AchievementsTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

// TODO: use delegate to pass data
class AchievementsTableViewCell: UITableViewCell {

  @IBOutlet weak var collectionViewHight: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!


  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  func setCollectionViewHight(row: Int) {
    switch row {
    case 0:
      collectionViewHight.constant = 110
    default:
      collectionViewHight.constant = 230
    }
  }
}

extension AchievementsTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementsCollectionViewCell", for: indexPath)
    cell.layer.cornerRadius = 10
    return cell
  }


}
extension AchievementsTableViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // delegate.showPopView()
  }
}
