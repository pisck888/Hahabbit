//
//  AddNewGoalDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import FirebaseStorage

class AddNewGoalDetailViewController: UITableViewController {

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
  @IBOutlet weak var detailTextView: UITextView!
  @IBOutlet weak var photoImage: UIImageView!

  var reminders = ["+"]
  let location = ["台北市", "新北市", "桃園市", "台中市", "台南市", "高雄市"]
  let weekday = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]
  let icon = ["accordion", "dollar", "water", "accordion", "dollar", "water",
              "accordion", "dollar", "water", "accordion", "dollar", "water",
              "accordion", "dollar", "water", "accordion", "dollar", "water",
              "accordion", "dollar", "water", "accordion", "dollar", "water",
              "accordion", "dollar", "water", "accordion", "dollar", "water"]
  var type = ""
  var hours: [Int] = []
  var minutes: [Int] = []
  var newHabit = Habit(
    id: "",
    title: "",
    weekday: ["1": false, "2": false, "3": false, "4": false, "5": false, "6": false, "7": false],
    slogan: "",
    members: [HabitManager.shared.currentUser],
    detail: "",
    location: "",
    owner: HabitManager.shared.currentUser,
    type: ["0": true, "1": false, "2": true, "3": false, "4": false, "5": false, "6": false],
    icon: "",
    photo: ""
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    newHabit.type[type] = true
  }

  @IBAction func pressPublicButton(_ sender: UIButton) {
    sender.isSelected.toggle()
    newHabit.type["1"]?.toggle()
    newHabit.type["2"]?.toggle()
  }

  @IBAction func pressDoneButton(_ sender: UIButton) {
    uploadNewHabit()
    navigationController?.popViewController(animated: true)
  }
  @IBAction func pressAddImageButton(_ sender: UIButton) {
    showImagePickerActionSheet()
  }

  func uploadNewHabit() {
    guard let imageData = photoImage.image?.pngData() else { return }
    let uniqueString = UUID().uuidString
    let storageRef = Storage.storage().reference().child("HahabbitUpload").child("\(uniqueString).png")
    storageRef.putData(imageData, metadata: nil) { data, error in
      if let err = error {
        print(err.localizedDescription)
      } else {
        storageRef.downloadURL { url, error in
          guard let url = url, error == nil else {
            print(error)
            return
          }
          self.newHabit.photo = url.absoluteString
          print(url.absoluteString)
          HabitManager.shared.addNewHabit(habit: self.newHabit, hours: self.hours, minutes: self.minutes)
          HabitManager.shared.setAllNotifications()
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
      return location.count
    case iconCollectionView:
      return icon.count
    case frequencyCollectionView:
      return weekday.count
    default:
      return reminders.count
    }

  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    switch collectionView {

    case locationCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as! FrequencyCell
      cell.setup(string: location[indexPath.row])
      if cell.isSelected == true {
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
      } else {
        cell.layer.borderWidth = 0
      }
      return cell

    case iconCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCell
      cell.setup(string: icon[indexPath.row])
      if cell.isSelected == true {
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
      } else {
        cell.layer.borderWidth = 0
      }
      return cell

    case frequencyCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frequencyCell", for: indexPath) as! FrequencyCell
      cell.setup(string: weekday[indexPath.row])
      if cell.isSelected == true {
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
      } else {
        cell.layer.borderWidth = 0
      }
      return cell

    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "remindersCell", for: indexPath) as! FrequencyCell
      cell.lebel.text = reminders[indexPath.row]
      return cell
    }
  }


}

extension AddNewGoalDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    switch collectionView {
    case iconCollectionView:
      newHabit.icon = (collectionView.cellForItem(at: indexPath) as! IconCell).imageName ?? ""
      setCellStates(collectionView: collectionView, indexPath: indexPath)

    case locationCollectionView:
      newHabit.location = (collectionView.cellForItem(at: indexPath) as! FrequencyCell).lebel.text ?? ""
      setCellStates(collectionView: collectionView, indexPath: indexPath)

    case frequencyCollectionView:
      newHabit.weekday[String(indexPath.row + 1)]?.toggle()
      setCellStates(collectionView: collectionView, indexPath: indexPath)

    default:
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
            guard !(self?.reminders.contains("\(hour):\(minute)"))! else { return }
            self?.hours.append(hour)
            self?.minutes.append(minute)
            self?.reminders.insert("\(hour):\(minute)", at: (self?.reminders.count)! - 1)
            collectionView.reloadData()
          }

        }
        self.present(picker, animated: true, completion: nil)
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if collectionView == frequencyCollectionView {
      newHabit.weekday[String(indexPath.row + 1)]?.toggle()
    }
    collectionView.cellForItem(at: indexPath)?.isSelected = false
    collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 0
  }

  func setCellStates(collectionView: UICollectionView, indexPath: IndexPath) {
    collectionView.cellForItem(at: indexPath)?.isSelected = true
    collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 1
    collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.black.cgColor
  }
}

extension AddNewGoalDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
      photoImage.image = editedImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      photoImage.image = originalImage
    }
    dismiss(animated: true, completion: nil)
  }
}
