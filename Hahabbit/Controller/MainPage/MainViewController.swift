//
//  ViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit
import PinterestSegment

class MainViewController: UIViewController {

  @IBOutlet weak var segmentView: UIView!

  @IBOutlet weak var tableView: UITableView!
  var style = PinterestSegmentStyle()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: K.mainPageTableViewCell, bundle: nil), forCellReuseIdentifier: K.mainPageTableViewCell)

    setPinterestSegment()
    let segment = PinterestSegment(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: 40), segmentStyle: style, titles: ["All", "Public", "Private", "Art", "Sport", "Evening"])
    segmentView.addSubview(segment)
    segment.valueChange = { index in
      print(index)
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
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    MockData.goals.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.mainPageTableViewCell, for: indexPath) as! MainPageTableViewCell
    cell.backView.backgroundColor = MockData.colors[indexPath.row]
    cell.titleLabel.text = MockData.goals[indexPath.row]
    cell.selectionStyle = .none
    return cell
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SegueToDetail", sender: nil)
  }
}
