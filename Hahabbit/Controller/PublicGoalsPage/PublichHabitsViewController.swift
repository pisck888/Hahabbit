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
import IQKeyboardManagerSwift


class PublichHabitsViewController: UIViewController {

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentView: UIView!
  var style = PinterestSegmentStyle()
  let viewModel = PublicHabitViewModel()

  var testTitle = ""
  var searchHabitsArray: [Habit] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetchData()
    viewModel.publicHabits.bind { habits in
      self.searchHabitsArray = habits
      self.tableView.reloadData()
    }

    self.searchBar.delegate = self

    tableView.register(UINib(nibName: K.publicGoalsTableViewCell, bundle: nil), forCellReuseIdentifier: K.publicGoalsTableViewCell)

    setPinterestSegment()
    let segment = PinterestSegment(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: 40), segmentStyle: style, titles: ["跑步", "重訓", "英文", "日文", "減肥", "喝水", "冥想"])
    segmentView.addSubview(segment)
    segment.valueChange = { index in
      print(index)
      self.viewModel.fetchData(withType: index)
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
    testTitle = sender.titleLabel?.text ?? ""
  }
  @IBAction func pressTimePeriodButton(_ sender: UIButton) {
    CM.items = ["早上", "下午", "晚上", "不限"]
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
  }
  @IBAction func pressLocationButton(_ sender: UIButton) {
    CM.items = ["台北市", "新北市", "台中市", "不限"]
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as? PublicHabitDetailViewController
    if segue.identifier == "SegueToPublicHabitDetail" {
      controller?.habit = sender as? Habit
    }
  }
}

extension PublichHabitsViewController: ContextMenuDelegate {
  func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
    if testTitle == "種類" {
      print(123)
    }
    print(contextMenu, index)
    if item.title == "不限" {
      viewModel.fetchData()
    } else {
      viewModel.fetchData(withLocation: item.title)
    }
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

extension PublichHabitsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchHabitsArray.count

//    viewModel.publicHabits.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.publicGoalsTableViewCell, for: indexPath) as! PublicGoalsTableViewCell
    cell.setup(with: searchHabitsArray[indexPath.row])

//    cell.setup(with: viewModel.publicHabits.value[indexPath.row])
    cell.selectionStyle = .none
    return cell
  }


}

extension PublichHabitsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let habit = searchHabitsArray[indexPath.row]
    performSegue(withIdentifier: "SegueToPublicHabitDetail", sender: habit)
  }
}

extension PublichHabitsViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)

    searchHabitsArray = searchText.isEmpty ? viewModel.publicHabits.value : viewModel.publicHabits.value.filter { habit in
      return habit.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print(12344)
//    searchBar.resignFirstResponder()
    searchBar.endEditing(true)
  }
}
