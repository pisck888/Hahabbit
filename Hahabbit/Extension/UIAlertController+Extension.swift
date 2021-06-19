//
//  UIAlertController+Extension.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/18.
//

import UIKit

extension UIAlertController {

  public func addDatePicker(mode: UIDatePicker.Mode, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: DatePickerViewController.Action?) {
    let datePicker = DatePickerViewController(
      mode: mode,
      date: date,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      action: action
    )
    set(vc: datePicker, height: 217)
  }
}

final public class DatePickerViewController: UIViewController {

  public typealias Action = (Date) -> Void

  private var action: Action?

  private lazy var datePicker: UIDatePicker = { [unowned self] in
    if #available(iOS 13.4, *) {
      $0.preferredDatePickerStyle = .wheels
    } else {
      // Fallback on earlier versions
    }
    $0.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
    return $0
  }(UIDatePicker())

  required public init(mode: UIDatePicker.Mode, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: Action?) {
    super.init(nibName: nil, bundle: nil)
    datePicker.datePickerMode = mode
    datePicker.date = date ?? Date()
    datePicker.minimumDate = minimumDate
    datePicker.maximumDate = maximumDate
    self.action = action
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
  }

  override public func loadView() {
    view = datePicker
  }

  @objc func actionForDatePicker() {
    action?(datePicker.date)
  }

  public func setDate(_ date: Date) {
    datePicker.setDate(date, animated: true)
  }
}
