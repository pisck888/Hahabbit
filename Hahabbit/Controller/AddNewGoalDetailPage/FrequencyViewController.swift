//
//  FrequencyViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit

class FrequencyViewController: UIViewController {

  @IBOutlet weak var dailyCollectionView: UICollectionView!
  @IBOutlet weak var weeklyCollectionView: UICollectionView!
  @IBOutlet weak var monthlyCollectionView: UICollectionView!

  let weekday = ["Mon.", "Tue.", "Wed.", "Thu", "Fri", "Sat", "Sun"]

  override func viewDidLoad() {
    super.viewDidLoad()
  }

}
extension FrequencyViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case dailyCollectionView:
      return  weekday.count
    case weeklyCollectionView:
      return 6
    default:
      return 30
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case dailyCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! FrequencyCell
      cell.lebel.text = weekday[indexPath.row]
      return cell
    case weeklyCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCell", for: indexPath) as! FrequencyCell
      cell.lebel.text = String(indexPath.row + 1)
      return cell
    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthlyCell", for: indexPath) as! FrequencyCell
      cell.lebel.text = String(indexPath.row + 1)
      return cell
    }
  }
}

extension FrequencyViewController: UICollectionViewDelegate {
}

