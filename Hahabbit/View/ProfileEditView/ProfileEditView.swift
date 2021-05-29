//
//  ProfileEditView.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/29.
//

import UIKit

class ProfileEditView: UIView {

  var user: User?

  @IBOutlet weak var pickerView: UIPickerView! {
    didSet {
      pickerView.dataSource = self
      pickerView.delegate = self
    }
  }
  @IBOutlet weak var textField: UITextField! {
    didSet {
      textField.delegate = self
    }
  }
}

extension ProfileEditView: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    user?.titleArray.count ?? 0
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    user?.titleArray[row]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    UserManager.shared.updateTitle(newTitle: user?.titleArray[row] ?? "新手")
  }


}

extension ProfileEditView: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    UserManager.shared.updateName(newName: textField.text ?? "使用者")
  }
}
