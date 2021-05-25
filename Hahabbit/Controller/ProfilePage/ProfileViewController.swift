//
//  SettingsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit
import FirebaseFirestoreSwift
import CustomizableActionSheet


class ProfileViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  let settingsTitle = ["Language", "Vibrate", "Dark Mode", "Touch ID"]

  var items: [CustomizableActionSheetItem] = []

  var user: User? {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    HabitManager.shared.db
      .collection("users")
      .whereField("id", isEqualTo: HabitManager.shared.currentUser)
      .getDocuments { querySnapshot, error in
        self.user = try? querySnapshot?.documents[0].data(as: User.self)
        print(self.user)
      }
    setupActionSheetItem(string: "English")
    setupActionSheetItem(string: "Traditional Chinese")
  }

  func setupActionSheetItem(string: String) {
    // Setup button
    let item = CustomizableActionSheetItem()
    item.type = .button
    item.label = string
    item.height = 60
    item.textColor = .black
    item.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
      actionSheet.dismiss()
    }
    items.append(item)
  }
}

extension ProfileViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    default:
      return settingsTitle.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
      if let user = user {
        cell.setup(user: user)
      }
      cell.selectionStyle = .none
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
      cell.titleLabel.text = settingsTitle[indexPath.row]
      cell.selectionStyle = .none
      return cell
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 120
    default:
      return 60
    }
  }
}
extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {

      // Show
      let actionSheet = CustomizableActionSheet()
      actionSheet.showInView(self.view, items: items)
    }
  }

}
