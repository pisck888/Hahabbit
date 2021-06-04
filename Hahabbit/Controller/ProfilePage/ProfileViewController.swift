//
//  SettingsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit
import FirebaseFirestoreSwift
import CustomizableActionSheet
import Kingfisher

class ProfileViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  let settingsTitle = ["Language", "blacklist", "Vibrate", "Dark Mode", "Touch ID"]

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
      let profileEditViewItem = CustomizableActionSheetItem(type: .view, height: 300)
      profileEditViewItem.view = profileEditView
      items.append(profileEditViewItem)
    }

    let cancelItem = CustomizableActionSheetItem(type: .button)
    cancelItem.label = "Cancel"
    cancelItem.textColor = .black
    cancelItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
      actionSheet.dismiss()
    }
    items.append(cancelItem)

    let actionSheet = CustomizableActionSheet()
    actionSheet.showInView(self.view, items: items)
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
      cell.setup(user: viewModel.currentUserViewModel.value)
      cell.selectionStyle = .none
      cell.layer.masksToBounds = false
      cell.clipsToBounds = false
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
      switch indexPath.row {
      case 0:
        let actionSheet = CustomizableActionSheet()
        actionSheet.showInView(self.view, items: items)
      case 1:
        performSegue(withIdentifier: Segue.toBlacklistPage, sender: nil)
      default:
        print("nothing happened")
      }
    }
  }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//  func showImagePickerActionSheet() {
//    let alert = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)
//
//    let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { action in
//      self.showImagePicker(sourceType: .photoLibrary)
//    }
//
//    let cameraAction = UIAlertAction(title: "Take from camera", style: .default) { action in
//      self.showImagePicker(sourceType: .camera)
//    }
//
//    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//
//    alert.addAction(photoLibraryAction)
//    alert.addAction(cameraAction)
//    alert.addAction(cancelAction)
//
//    present(alert, animated: true, completion: nil)
//  }

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
