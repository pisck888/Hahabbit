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

  let viewModel = HomeViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    viewModel.habitViewModels.bind { [weak self] habits in
      self?.viewModel.onRefresh()
    }

    viewModel.fetchData()

    tableView.register(UINib(nibName: K.mainPageTableViewCell, bundle: nil), forCellReuseIdentifier: K.mainPageTableViewCell)

    setPinterestSegment()
    let segment = PinterestSegment(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: 40), segmentStyle: style, titles: ["All", "Public", "Private", "Art", "Sport", "Evening"])
    segmentView.addSubview(segment)

    segment.valueChange = { index in
      self.viewModel.fetchData(type: index)
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
    viewModel.habitViewModels.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: K.mainPageTableViewCell, for: indexPath) as? MainPageTableViewCell else {
      return MainPageTableViewCell()
    }
    let cellViewModel = viewModel.habitViewModels.value[indexPath.row]
    cell.setup(with: cellViewModel)
    cell.selectionStyle = .none
    return cell
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SegueToDetail", sender: nil)
  }
}
