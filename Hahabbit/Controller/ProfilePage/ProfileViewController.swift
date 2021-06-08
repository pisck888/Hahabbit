//
//  SettingsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import CustomizableActionSheet
import Kingfisher

class ProfileViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  let settingsTitle = ["語言設置", "封鎖名單", "震動功能", "暗黑模式", "主題顏色", "Touch ID"]

  var items: [CustomizableActionSheetItem] = []

  let viewModel = ProfileViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backButtonTitle = ""

    viewModel.currentUserViewModel.bind { user in
      self.tableView.reloadData()
    }
    viewModel.fetchCurrentUser()
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

  @IBAction func changePhotoImage(_ sender: UIButton) {
    var items = [CustomizableActionSheetItem]()
    let cameraItem = CustomizableActionSheetItem()
    cameraItem.type = .button
    cameraItem.label = "Take from camera"
    cameraItem.height = 60
    cameraItem.textColor = .black
    cameraItem.selectAction = { action -> Void in
      self.showImagePicker(sourceType: .camera)
      action.dismiss()
    }
    items.append(cameraItem)

    let libraryItem = CustomizableActionSheetItem()
    libraryItem.type = .button
    libraryItem.label = "Choose from library"
    libraryItem.height = 60
    libraryItem.textColor = .black
    libraryItem.selectAction = { action -> Void in
      self.showImagePicker(sourceType: .photoLibrary)
      action.dismiss()
    }
    items.append(libraryItem)

    let actionSheet = CustomizableActionSheet()
    actionSheet.showInView(self.view, items: items)
  }

  @IBAction func changeNameAndTitle(_ sender: UIButton) {
    var items = [CustomizableActionSheetItem]()

    // First view
    if let profileEditView = UINib(nibName: "ProfileEditView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ProfileEditView {
      profileEditView.user = viewModel.currentUserViewModel.value
      profileEditView.textField.text = viewModel.currentUserViewModel.value.name
      let profileEditViewItem = CustomizableActionSheetItem(type: .view, height: 300)
      profileEditViewItem.view = profileEditView
      items.append(profileEditViewItem)
    }

    let OKItem = CustomizableActionSheetItem(type: .button)
    OKItem.label = "OK"
    OKItem.textColor = .black
    OKItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
      actionSheet.dismiss()
    }
    items.append(OKItem)

    let actionSheet = CustomizableActionSheet()
    actionSheet.showInView(self.view, items: items)
  }
}

extension ProfileViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return settingsTitle.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
      cell.setup(user: viewModel.currentUserViewModel.value)
      cell.selectionStyle = .none
      cell.layer.masksToBounds = false
      cell.clipsToBounds = false
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
      cell.titleLabel.text = settingsTitle[indexPath.row]
      cell.selectionStyle = .none
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath)
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
      switch indexPath.row {
      case 0:
        let actionSheet = CustomizableActionSheet()
        actionSheet.showInView(self.view, items: items)
      case 1:
        performSegue(withIdentifier: MySegue.toBlacklistPage, sender: nil)
      default:
        print("nothing happened")
      }
    }
    if indexPath.section == 2 {
      let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
      } catch let signOutError as NSError {
        print("Error signing out: %@", signOutError)
      }
      performSegue(withIdentifier: MySegue.toLoginPage, sender: nil)
    }
  }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func showImagePicker(sourceType: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = sourceType
    present(imagePicker, animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      guard let imageData = editedImage.pngData() else { return }
      UserManager.shared.uploadAvatarImage(imageData: imageData)
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      guard let imageData = originalImage.pngData() else { return }
      UserManager.shared.uploadAvatarImage(imageData: imageData)
    }
    dismiss(animated: true, completion: nil)
  }
}
