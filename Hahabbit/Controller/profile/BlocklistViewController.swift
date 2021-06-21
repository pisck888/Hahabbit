//
//  BlacklistViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/4.
//

import UIKit

class BlocklistViewController: UIViewController {

  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet var popupView: UIView!
  @IBOutlet weak var tableView: UITableView!

  var user: User?
  var viewModel = BlocklistViewModel()
  var currentUserViewModel = ProfileViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "封鎖名單".localized()

    viewModel.blockedUsersViewModel.bind { _ in
      self.showPopView()
      self.tableView.reloadData()
    }

    currentUserViewModel.currentUserViewModel.bind { _ in
      let blocklist = self.currentUserViewModel.currentUserViewModel.value.blocklist
      self.viewModel.fetchBlockedUsers(blockedUsers: blocklist)
    }

    currentUserViewModel.fetchCurrentUser()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    showPopView()
  }

  func showPopView() {
    if viewModel.blockedUsersViewModel.value.isEmpty {
      messageLabel.text = "封鎖名單目前還是空的唷～".localized()
      popupView.setCornerRadiusAndShadow()
      popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      popupView.center = tableView.center
      view.addSubview(popupView)

      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0.5,
        options: .curveLinear
      ) {
        self.popupView.transform = .identity
      }
    } else {
      popupView.removeFromSuperview()
    }
  }

  @IBAction func pressUnblockButton(_ sender: UIButton) {
    let buttonPosition: CGPoint = sender.convert(.zero, to: tableView)
    if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
      let userID = viewModel.blockedUsersViewModel.value[indexPath.row].id
      UserManager.shared.unBlockUser(id: userID)
      viewModel.blockedUsersViewModel.value.remove(at: indexPath.row)
    }
  }
}

extension BlocklistViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.blockedUsersViewModel.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: BlocklistTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    cell.setup(blocklistUser: viewModel.blockedUsersViewModel.value[indexPath.row])
    return cell
  }
}
