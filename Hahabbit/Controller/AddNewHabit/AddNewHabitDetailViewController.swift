//
//  AddNewHabitDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import FirebaseStorage
import Kingfisher
import PopupDialog
import JGProgressHUD
import Localize_Swift

protocol AddNewHabitDetailViewControllerDelegate: AnyObject {
  func setNewData(data: Habit, photo: String)
}

class AddNewHabitDetailViewController: UITableViewController {

  weak var delegate: AddNewHabitDetailViewControllerDelegate?

  @IBOutlet weak var frequencyCollectionView: UICollectionView! {
    didSet {
      frequencyCollectionView.allowsMultipleSelection = true
    }
  }
  @IBOutlet weak var locationCollectionView: UICollectionView!
  @IBOutlet weak var iconCollectionView: UICollectionView!
  @IBOutlet weak var remindersCollectionView: UICollectionView!

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var remindersLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var publicLabel: UILabel!
  @IBOutlet weak var photoLabel: UILabel!

  @IBOutlet weak var publicButton: UIButton!

  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var messageTextField: UITextField!

  @IBOutlet weak var detailTextView: UITextView! {
    didSet {
      detailTextView.layer.cornerRadius = 5
      detailTextView.layer.borderColor = UIColor.systemGray5.cgColor
      detailTextView.layer.borderWidth = 1
    }
  }
  @IBOutlet weak var photoImage: UIImageView! {
    didSet {
      photoImage.layer.cornerRadius = 10
      photoImage.clipsToBounds = true
    }
  }
  @IBOutlet weak var plusBackViewLabel: UILabel! {
    didSet {
      plusBackViewLabel.layer.cornerRadius = 10
      plusBackViewLabel.clipsToBounds = true
    }
  }
  let loadingVC = LoadingViewController()

  var reminders = ["+"] {
    didSet {
      remindersCollectionView.reloadData()
    }
  }
  var isPlusLabelHidden = false
  var type = ""
  var hours: [Int] = []
  var minutes: [Int] = []
  var selectedIconIndexPath: IndexPath = [0, 0] {
    didSet {
      iconCollectionView.reloadData()
    }
  }
  var selectedLocationIndexPath: IndexPath = [0, 0] {
    didSet {
      locationCollectionView.reloadData()
    }
  }
  var newHabit = Habit(
    id: "",
    title: "",
    weekday: ["1": true, "2": true, "3": true, "4": true, "5": true, "6": true, "7": true],
    slogan: "",
    members: [UserManager.shared.currentUser],
    detail: "",
    location: MyArray.locationArray[0],
    owner: UserManager.shared.currentUser,
    type: ["0": true, "1": false, "2": true, "3": false, "4": false, "5": false, "6": false],
    icon: MyArray.habitIconArray[0],
    photo: ""
  )
  var editHabit: Habit?
  var viewModel = NotificationsViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    newHabit.type[type] = true

    setText()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setText),
      name: NSNotification.Name(LCLLanguageChangeNotification),
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setThemeColor),
      name: NSNotification.Name(K.changeThemeColor  ),
      object: nil
    )

    viewModel.notification.bind { [unowned self] notification in
      guard let time = notification else { return }
      self.reminders.insert(time, at: self.reminders.count - 1)
    }

    viewModel.hour.bind { [unowned self] hour in
      guard let hour = hour else { return }
      self.hours.append(hour)
    }

    viewModel.minute.bind { [unowned self] minute in
      guard let minute = minute else { return }
      self.minutes.append(minute)
    }
    if editHabit == nil {
      for i in 0...6 {
        frequencyCollectionView.selectItem(at: [0, i], animated: true, scrollPosition: [])
      }
    } else {
      viewModel.fetchNotifications(id: editHabit?.id ?? "")
      setEditHabit()
    }
  }

  @objc func setText() {
    navigationItem.title = "????????????".localized()
    titleTextField.placeholder = "??????????????????????????????????????????".localized()
    messageTextField.placeholder = "????????????????????????????????????".localized()
    setLabelString()
    reloadAllCollectionView()
  }

  @objc func setThemeColor() {
    reloadAllCollectionView()
  }

  func reloadAllCollectionView() {
    iconCollectionView.reloadData()
    locationCollectionView.reloadData()
    frequencyCollectionView.reloadData()
    remindersCollectionView.reloadData()
    selectWeekdayCell()
  }

  func selectWeekdayCell() {
    for i in 1...7 {
      if newHabit.weekday[String(i)] == true {
        frequencyCollectionView.selectItem(at: [0, i - 1], animated: true, scrollPosition: [])
      } else {
        frequencyCollectionView.deselectItem(at: [0, i - 1], animated: true)
      }
    }
  }

  @IBAction func pressPublicButton(_ sender: UIButton) {
    sender.isSelected.toggle()
    newHabit.type["1"]?.toggle()
    newHabit.type["2"]?.toggle()
  }

  @IBAction func pressDoneButton(_ sender: UIButton) {
    guard
      !(titleTextField.text ?? "").isEmpty,
      !(messageTextField.text ?? "").isEmpty,
      !(detailTextView.text ?? "").isEmpty,
      photoImage.image != nil
    else
    {
      showAlertPopup()
      return
    }
    uploadNewHabit()
    loadingVC.modalTransitionStyle = .crossDissolve
    loadingVC.modalPresentationStyle = .overFullScreen
    present(loadingVC, animated: true, completion: nil)
  }

  @IBAction func pressAddImageButton(_ sender: UIButton) {
    showImagePickerActionSheet()
  }

  func setLabelString() {
    nameLabel.text = "????????????".localized()
    iconLabel.text = "????????????".localized()
    locationLabel.text = "????????????".localized()
    frequencyLabel.text = "????????????".localized()
    remindersLabel.text = "????????????".localized()
    messageLabel.text = "????????????".localized()
    detailLabel.text = "????????????".localized()
    publicLabel.text = "????????????".localized()
    photoLabel.text = "????????????".localized()
  }

  func showAlertPopup() {
    ImpactFeedbackGenerator.impactOccurred()

    let popup = PopupDialog(
      title: "??????????????????????????????".localized(),
      message: "????????????????????????????????????????????????".localized()
    )
    let okButton = CancelButton(title: "??????".localized()) {
    }
    popup.addButton(okButton)

    popup.transitionStyle = .zoomIn
    PopupDialogContainerView.appearance().cornerRadius = 10

    self.present(popup, animated: true) {
      popup.shake()
    }
  }

  func uploadNewHabit() {
    HabitManager.shared.uploadHabit(habit: self.newHabit, hours: self.hours, minutes: self.minutes) { habitID in
      guard let imageData = self.photoImage.image?.pngData() else { return }
      let storageRef = Storage
        .storage()
        .reference()
        .child("HahabbitUpload")
        .child("\(habitID).png")
      storageRef.putData(imageData, metadata: nil) { data, error in
        if let err = error {
          print(err)
        } else {
          storageRef.downloadURL { url, error in
            guard let url = url, error == nil else {
              print(error as Any)
              return
            }
            self.newHabit.photo = url.absoluteString
            HabitManager.shared.database
              .collection("habits")
              .document(habitID)
              .updateData(["photo": url.absoluteString])
            HabitManager.shared.setAllNotifications()
            self.delegate?.setNewData(data: self.newHabit, photo: url.absoluteString)
            self.loadingVC.dismiss(animated: true) {
              self.navigationController?.popViewController(animated: true)
              self.presentDoneAlert()
            }
          }
        }
      }
    }
  }

  func presentDoneAlert() {
    let hud = JGProgressHUD()
    hud.textLabel.text = "??????".localized()
    hud.square = true
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    hud.show(in: (self.navigationController?.view)!, animated: true)
    hud.dismiss(afterDelay: 1.5)
  }

  func setEditHabit() {
    if let editHabit = editHabit {
      newHabit = editHabit
      let url = URL(string: editHabit.photo)
      titleTextField.text = editHabit.title
      messageTextField.text = editHabit.slogan
      detailTextView.text = editHabit.detail
      photoImage.kf.setImage(with: url)
      plusBackViewLabel.isHidden = isPlusLabelHidden
      publicButton.isSelected = editHabit.type["1"] ?? true
      if let indexRow = MyArray.habitIconArray.firstIndex(where: { $0 == editHabit.icon }) {
        selectedIconIndexPath = [0, indexRow]
      }
      if let indexRow = MyArray.locationArray.firstIndex(where: { $0 == editHabit.location }) {
        selectedLocationIndexPath = [0, indexRow]
      }
      selectWeekdayCell()
    }
  }
}

extension AddNewHabitDetailViewController: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    switch textField {
    case titleTextField:
      newHabit.title = text
    default:
      newHabit.slogan = text
    }
  }
}

extension AddNewHabitDetailViewController: UITextViewDelegate {
  func textViewDidChangeSelection(_ textView: UITextView) {
    newHabit.detail = textView.text
  }
}

extension AddNewHabitDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case locationCollectionView:
      return MyArray.locationArray.count - 1
    case iconCollectionView:
      return MyArray.habitIconArray.count
    case frequencyCollectionView:
      return MyArray.weekdayArray.count
    default:
      return reminders.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    switch collectionView {
    case iconCollectionView:
      let cell: IconCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
      cell.setup(imageName: MyArray.habitIconArray[indexPath.row])
      if indexPath == selectedIconIndexPath {
        cell.isSelected = true
      }
      setCellAppearance(cell: cell)
      return cell

    case locationCollectionView:
      let cell: SelectableCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
      cell.setup(string: MyArray.locationArray[indexPath.row].localized())
      if indexPath == selectedLocationIndexPath {
        cell.isSelected = true
      }
      setCellAppearance(cell: cell)
      return cell

    case frequencyCollectionView:
      let cell: SelectableCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
      cell.setup(string: MyArray.weekdayArray[indexPath.row].localized())
      setCellAppearance(cell: cell)
      return cell

    default:
      let cell: SelectableCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
      cell.setup(indexPath: indexPath, reminders: reminders)
      return cell
    }
  }

  func setCellAppearance(cell: UICollectionViewCell) {
    if cell.isSelected == true {
      cell.layer.borderWidth = 1
      cell.layer.borderColor = UIColor.black.cgColor
      cell.contentView.backgroundColor = UserManager.shared.themeColor.withAlphaComponent(0.3)
    } else {
      cell.layer.borderWidth = 0
      cell.contentView.backgroundColor = .systemGray6
    }
  }
}

extension AddNewHabitDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    switch collectionView {
    case iconCollectionView:
      newHabit.icon = (cell as? IconCollectionViewCell)?.imageName ?? ""
      selectedIconIndexPath = indexPath

    case locationCollectionView:
      newHabit.location = (cell as? SelectableCollectionViewCell)?.lebel.text ?? ""
      selectedLocationIndexPath = indexPath

    case frequencyCollectionView:
      newHabit.weekday[String(indexPath.row + 1)]?.toggle()
      cell.isSelected = true
      setCellAppearance(cell: cell)

    case remindersCollectionView:
      setReminders(collectionView: collectionView, indexPath: indexPath)

    default:
      print("error")
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    if collectionView == frequencyCollectionView {
      newHabit.weekday[String(indexPath.row + 1)]?.toggle()
    }
    cell.isSelected = false
    setCellAppearance(cell: cell)
  }

  func setReminders(collectionView: UICollectionView, indexPath: IndexPath) {
    if collectionView == remindersCollectionView && indexPath.row == reminders.count - 1 {
      let alert = UIAlertController(title: "????????????".localized(), message: nil, preferredStyle: .actionSheet)
      var stringHour = ""
      var stringMinute = ""
      var hour = 0 {
        didSet {
          switch hour {
          case 0...9:
            stringHour = "0\(hour)"
          default:
            stringHour = String(hour)
          }
        }
      }
      var minute = 0 {
        didSet {
          switch minute {
          case 0...9:
            stringMinute = "0\(minute)"
          default:
            stringMinute = String(minute)
          }
        }
      }
      hour = Calendar.current.component(.hour, from: Date())
      minute = Calendar.current.component(.minute, from: Date())
      alert.view.tintColor = .darkGray
      alert.addDatePicker(mode: .time, date: Date()) { date in
        hour = Calendar.current.component(.hour, from: date)
        minute = Calendar.current.component(.minute, from: date)
      }
      alert.addAction(title: "??????".localized(), style: .default) { _ in
        guard !(self.reminders.contains("\(stringHour):\(stringMinute)")) else { return }
        self.hours.append(hour)
        self.minutes.append(minute)
        self.reminders.insert("\(stringHour):\(stringMinute)", at: (self.reminders.count) - 1)
      }
      alert.addAction(title: "??????".localized(), style: .cancel)
      present(alert, animated: true, completion: nil)
    } else {
      self.reminders.remove(at: indexPath.row)
      self.hours.remove(at: indexPath.row)
      self.minutes.remove(at: indexPath.row)
    }
  }
}

extension AddNewHabitDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func showImagePickerActionSheet() {
    let alert = UIAlertController(title: "????????????".localized(), message: nil, preferredStyle: .actionSheet)
    alert.view.tintColor = .darkGray
    let cameraAction = UIAlertAction(title: "????????????".localized(), style: .default) { _ in
      self.showImagePicker(sourceType: .camera)
    }
    let photoLibraryAction = UIAlertAction(title: "????????????".localized(), style: .default) { _ in
      self.showImagePicker(sourceType: .photoLibrary)
    }
    let cancelAction = UIAlertAction(title: "??????".localized(), style: .cancel, handler: nil)

    alert.addAction(cameraAction)
    alert.addAction(photoLibraryAction)
    alert.addAction(cancelAction)

    if let popoverController = alert.popoverPresentationController {
      popoverController.sourceView = self.view
      popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
      popoverController.permittedArrowDirections = []
    }
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
      photoImage.image = editedImage
      plusBackViewLabel.isHidden = true
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      photoImage.image = originalImage
      plusBackViewLabel.isHidden = true
    }
    dismiss(animated: true, completion: nil)
  }
}
