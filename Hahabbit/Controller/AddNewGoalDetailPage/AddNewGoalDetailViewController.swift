//
//  AddNewGoalDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import FirebaseStorage
import Kingfisher
import PopupDialog
import JGProgressHUD

protocol AddNewGoalDetailViewControllerDelegate: AnyObject {
  func setNewData(data: Habit, photo: String)
}

class AddNewGoalDetailViewController: UITableViewController {

  weak var delegate: AddNewGoalDetailViewControllerDelegate?

  @IBOutlet weak var frequencyCollectionView: UICollectionView! {
    didSet {
      frequencyCollectionView.allowsMultipleSelection = true
    }
  }
  @IBOutlet weak var locationCollectionView: UICollectionView!
  @IBOutlet weak var iconCollectionView: UICollectionView!
  @IBOutlet weak var remindersCollectionView: UICollectionView!

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

    viewModel.notification.bind { notification in
      guard let time = notification else { return }
      self.reminders.insert(time, at: self.reminders.count - 1)
    }

    viewModel.hour.bind { hour in
      guard let hour = hour else { return }
      self.hours.append(hour)
    }

    viewModel.minute.bind { minute in
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

  @IBAction func pressPublicButton(_ sender: UIButton) {
    sender.isSelected.toggle()
    newHabit.type["1"]?.toggle()
    newHabit.type["2"]?.toggle()
  }

  @IBAction func pressDoneButton(_ sender: UIButton) {
    if (titleTextField.text ?? "").isEmpty ||
        (messageTextField.text ?? "").isEmpty ||
        (detailTextView.text ?? "").isEmpty ||
        photoImage.image == nil {
      showAlertPopup()
    } else {
      uploadNewHabit()
      loadingVC.modalTransitionStyle = .crossDissolve
      loadingVC.modalPresentationStyle = .overFullScreen
      present(loadingVC, animated: true, completion: nil)
    }
  }
  @IBAction func pressAddImageButton(_ sender: UIButton) {
    showImagePickerActionSheet()
  }

  func showAlertPopup() {
    let popup = PopupDialog(
      title: "有些欄位還是空的唷！",
      message: "確認所有的欄位都輸入了正確的資訊"
    )
    let buttonOne = CancelButton(title: "OK") {
    }
    popup.addButton(buttonOne)

    let containerAppearance = PopupDialogContainerView.appearance()
    popup.transitionStyle = .zoomIn
    containerAppearance.cornerRadius = 10

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
          print(err.localizedDescription)
        } else {
          storageRef.downloadURL { url, error in
            guard let url = url, error == nil else {
              print(error as Any)
              return
            }
            print(url.absoluteString)
            self.newHabit.photo = url.absoluteString
            HabitManager.shared.db.collection("habits").document(habitID).updateData(["photo": url.absoluteString])
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
    hud.textLabel.text = "完成"
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
      for i in 1...7 {
        newHabit.weekday[String(i)] = editHabit.weekday[String(i)]
        if editHabit.weekday[String(i)] == true {
          frequencyCollectionView.selectItem(at: [0, i - 1], animated: true, scrollPosition: [])
        }
      }
    }
  }
}

extension AddNewGoalDetailViewController: UITextFieldDelegate {
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

extension AddNewGoalDetailViewController: UITextViewDelegate {
  func textViewDidChangeSelection(_ textView: UITextView) {
    newHabit.detail = textView.text
  }
}

extension AddNewGoalDetailViewController: UICollectionViewDataSource {
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
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCell
      cell.setup(imageName: MyArray.habitIconArray[indexPath.row])
      if indexPath == selectedIconIndexPath {
        cell.isSelected = true
      }
      setCellSelectedStatus(cell: cell)
      return cell

    case locationCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as! FrequencyCell
      cell.setup(string: MyArray.locationArray[indexPath.row])
      if indexPath == selectedLocationIndexPath {
        cell.isSelected = true
      }
      setCellSelectedStatus(cell: cell)
      return cell

    case frequencyCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frequencyCell", for: indexPath) as! FrequencyCell
      cell.setup(string: MyArray.weekdayArray[indexPath.row])
      setCellSelectedStatus(cell: cell)
      return cell

    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "remindersCell", for: indexPath) as! FrequencyCell
      cell.lebel.text = reminders[indexPath.row]
      return cell
    }
  }

  func setCellSelectedStatus(cell: UICollectionViewCell) {
    if cell.isSelected == true {
      cell.layer.borderWidth = 1
      cell.layer.borderColor = UIColor.black.cgColor
      cell.contentView.backgroundColor = .systemGray4
    } else {
      cell.layer.borderWidth = 0
      cell.contentView.backgroundColor = .systemGray6
    }
  }
}

extension AddNewGoalDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case iconCollectionView:
      newHabit.icon = (collectionView.cellForItem(at: indexPath) as! IconCell).imageName ?? ""
      selectedIconIndexPath = indexPath
      setCellStates(collectionView: collectionView, indexPath: indexPath)

    case locationCollectionView:
      newHabit.location = (collectionView.cellForItem(at: indexPath) as! FrequencyCell).lebel.text ?? ""
      selectedLocationIndexPath = indexPath
      setCellStates(collectionView: collectionView, indexPath: indexPath)

    case frequencyCollectionView:
      newHabit.weekday[String(indexPath.row + 1)]?.toggle()
      setCellStates(collectionView: collectionView, indexPath: indexPath)

    case remindersCollectionView:
      setReminders(collectionView: collectionView, indexPath: indexPath)

    default:
      print("error")
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if collectionView == frequencyCollectionView {
      newHabit.weekday[String(indexPath.row + 1)]?.toggle()
    }
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.isSelected = false
    cell?.layer.borderWidth = 0
    cell?.contentView.backgroundColor = .systemGray6
  }

  func setCellStates(collectionView: UICollectionView, indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.isSelected = true
    cell?.layer.borderWidth = 1
    cell?.layer.borderColor = UIColor.black.cgColor
    cell?.contentView.backgroundColor = .systemGray4
  }

  func setReminders(collectionView: UICollectionView, indexPath: IndexPath) {
    if collectionView == remindersCollectionView && indexPath.row == reminders.count - 1 {
      let picker = PresentedViewController()
      picker.style.pickerMode = .time
      picker.style.pickerColor = .color(.black)
      picker.style.textColor = .black
      picker.style.titleString = "Set time"
      picker.block = { [weak self] date in
        if let date = date {
          let hour = Calendar.current.component(.hour, from: date)
          let minute = Calendar.current.component(.minute, from: date)
          var stringHour = ""
          var stringMinute = ""
          switch hour {
          case 0...9:
            stringHour = "0\(hour)"
          default:
            stringHour = String(hour)
          }
          switch minute {
          case 0...9:
            stringMinute = "0\(minute)"
          default:
            stringMinute = String(minute)
          }
          guard !(self?.reminders.contains("\(stringHour):\(stringMinute)"))! else { return }
          self?.hours.append(hour)
          self?.minutes.append(minute)
          self?.reminders.insert("\(stringHour):\(stringMinute)", at: (self?.reminders.count)! - 1)
        }
      }
      self.present(picker, animated: true, completion: nil)
    } else {
      self.reminders.remove(at: indexPath.row)
      self.hours.remove(at: indexPath.row)
      self.minutes.remove(at: indexPath.row)
    }
  }
}

extension AddNewGoalDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func showImagePickerActionSheet() {
    let alert = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)
    alert.view.tintColor = .black

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
      photoImage.image = editedImage
      plusBackViewLabel.isHidden = true
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      photoImage.image = originalImage
      plusBackViewLabel.isHidden = true
    }
    dismiss(animated: true, completion: nil)
  }
}
