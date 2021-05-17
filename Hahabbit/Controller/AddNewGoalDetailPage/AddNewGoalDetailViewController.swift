//
//  AddNewGoalDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import PinterestSegment

class AddNewGoalDetailViewController: UITableViewController {
  private enum FrequencyType: Int {
    case daily = 0
    case weekly = 1
    case monthly = 2
  }

  @IBOutlet weak var segmentView: UIView!
  @IBOutlet weak var iconCollectionView: UICollectionView!
  @IBOutlet weak var remindersCollectionView: UICollectionView!
  @IBOutlet weak var dailyContainerView: UIView!
  @IBOutlet weak var weeklyContainerView: UIView!
  @IBOutlet weak var monthlyContainerView: UIView!

  @IBOutlet weak var publicButton: UIButton!

  var containerViews: [UIView] {
    return [dailyContainerView, weeklyContainerView, monthlyContainerView]
  }
  var mockReminders = ["+"]

  var style = PinterestSegmentStyle()

  override func viewDidLoad() {
    super.viewDidLoad()
    setPinterestSegment()
    let segment = PinterestSegment(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 40), segmentStyle: style, titles: ["Daily", "Weekly", "Monthly"])
    segmentView.addSubview(segment)
    segment.valueChange = { index in
      guard let type = FrequencyType(rawValue: index) else { return }
      updateContainer(type: type)
    }

    func updateContainer(type: FrequencyType) {
      containerViews.forEach { $0.isHidden = true }
      switch type {
      case .daily:
        dailyContainerView.isHidden = false
      case .weekly:
        weeklyContainerView.isHidden = false
      case .monthly:
        monthlyContainerView.isHidden = false
      }
    }
  }

  func setPinterestSegment() {
    style.indicatorColor = UIColor(white: 0.95, alpha: 1)
    style.titleMargin = 10
    style.titlePendingHorizontal = 14
    style.titlePendingVertical = 14
    style.titleFont = UIFont.boldSystemFont(ofSize: 14)
    style.normalTitleColor = UIColor.lightGray
    style.selectedTitleColor = UIColor.darkGray
  }

  @IBAction func pressPublicButton(_ sender: UIButton) {
    sender.isSelected.toggle()
  }
  @IBAction func pressDoneButton(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }


}

extension AddNewGoalDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case iconCollectionView:
      return 39
    default:
      return mockReminders.count
    }

  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case iconCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath)
      return cell
    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "remindersCell", for: indexPath) as! FrequencyCell
      cell.lebel.text = mockReminders[indexPath.row]
      return cell
    }

  }


}

extension AddNewGoalDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == remindersCollectionView && indexPath.row == mockReminders.count - 1 {
      mockReminders.insert("12:00", at: 0)
      collectionView.reloadData()
    }
  }
}
