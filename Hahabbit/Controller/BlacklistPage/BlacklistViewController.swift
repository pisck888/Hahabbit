//
//  BlacklistViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/4.
//

import UIKit

class BlacklistViewController: UIViewController {

  var user: User?

  var viewModel = BlacklistViewModel()
  var currentUserViewModel = ProfileViewModel()

  @IBOutlet var popupView: UIView!
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.blockedUsersViewModel.bind { _ in
      self.showPopView()
      self.tableView.reloadData()
    }

    currentUserViewModel.currentUserViewModel.bind { _ in
      let blacklist = self.currentUserViewModel.currentUserViewModel.value.blacklist
      self.viewModel.fetchBlockedUsers(blockedUsers: blacklist)
    }
    currentUserViewModel.fetchCurrentUser()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    showPopView()
  }

  func showPopView() {
    if viewModel.blockedUsersViewModel.value.isEmpty {
      popupView.layer.shadowOffset = CGSize(width: 2, height: 2)
      popupView.layer.shadowOpacity = 0.5
      popupView.layer.shadowRadius = 2
      popupView.layer.shadowColor = UIColor.black.cgColor
      popupView.layer.cornerRadius = 10
      popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      popupView.center = tableView.center
      view.addSubview(popupView)

      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear) {
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

extension BlacklistViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.blockedUsersViewModel.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "blacklistCell", for: indexPath) as? BlacklistTableViewCell
    cell?.setup(blacklistUser: viewModel.blockedUsersViewModel.value[indexPath.row])
    cell?.selectionStyle = .none
    return cell ?? BlacklistTableViewCell()
  }
}
