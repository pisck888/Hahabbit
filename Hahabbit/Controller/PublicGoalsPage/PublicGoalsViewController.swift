//
//  PublicGoalsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import YNDropDownMenu
import ContextMenuSwift
import PinterestSegment


class PublicGoalsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentView: UIView!
  var style = PinterestSegmentStyle()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: K.publicGoalsTableViewCell, bundle: nil), forCellReuseIdentifier: K.publicGoalsTableViewCell)

    setPinterestSegment()
    let segment = PinterestSegment(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: 40), segmentStyle: style, titles: ["跑步", "重訓", "英文", "日文", "減肥", "喝水", "冥想"])
    segmentView.addSubview(segment)
    segment.valueChange = { index in
      print(index)
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


  @IBAction func pressTypeButton(_ sender: UIButton) {
    CM.items = ["健身運動", "學習技能", "自我管理", "其他自訂"]
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
  }
  @IBAction func pressTimePeriodButton(_ sender: UIButton) {
    CM.items = ["早上", "下午", "晚上", "不限"]
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
  }
  @IBAction func pressLocationButton(_ sender: UIButton) {
    CM.items = ["台北市", "新北市", "台中市", "高雄市"]
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
  }
}

extension PublicGoalsViewController: ContextMenuDelegate {
  func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
    print(item.title)
    return true
  }

  func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
  }

  func contextMenuDidAppear(_ contextMenu: ContextMenu) {
//    print("contextMenuDidAppear")
  }

  func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
//    print("contextMenuDidDisappear")
  }
}

extension PublicGoalsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.publicGoalsTableViewCell, for: indexPath) as! PublicGoalsTableViewCell
    cell.selectionStyle = .none
    return cell
  }


}

extension PublicGoalsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SegueToPublicGaolDetail", sender: nil)
  }

}
