//
//  SettingsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit
import FirebaseFirestoreSwift
import CustomizableActionSheet
import McPicker
import Kingfisher

class ProfileViewController: UIViewController {


  @IBOutlet weak var tableView: UITableView!
  let settingsTitle = ["Language", "Vibrate", "Dark Mode", "Touch ID"]

  var items: [CustomizableActionSheetItem] = []

  let viewModel = ProfileViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.userViewModel.bind { user in
      self.tableView.reloadData()
    }
    viewModel.fetchData()
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
    showImagePickerActionSheet()
  }
  @IBAction func changeNameAndTitle(_ sender: UIButton) {
    var items = [CustomizableActionSheetItem]()

    // First view
    if let profileEditView = UINib(nibName: "ProfileEditView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ProfileEditView {
      profileEditView.user = viewModel.userViewModel.value
      let profileEditViewItem = CustomizableActionSheetItem(type: .view, height: 300)
      profileEditViewItem.view = profileEditView
      items.append(profileEditViewItem)
    }

    // Second button
    let okItem = CustomizableActionSheetItem(type: .button)
    okItem.label = "OK"
    okItem.backgroundColor = UIColor(red: 1, green: 0.41, blue: 0.38, alpha: 1)
    okItem.textColor = UIColor.white
    okItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
      self.view.backgroundColor = UIColor.white
      actionSheet.dismiss()
    }
    items.append(okItem)

    // Third button
    let cancelItem = CustomizableActionSheetItem(type: .button)
    cancelItem.label = "Cancel"
    cancelItem.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
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
      cell.setup(user: viewModel.userViewModel.value)
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func showImagePickerActionSheet() {
    let alert = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)

    let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { action in
      self.showImagePicker(sourceType: .photoLibrary)
    }

    let cameraAction = UIAlertAction(title: "Take from camera", style: .default) { action in
      self.showImagePicker(sourceType: .camera)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

    alert.addAction(photoLibraryAction)
    alert.addAction(cameraAction)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }

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
