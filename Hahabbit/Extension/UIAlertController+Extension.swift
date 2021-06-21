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
    setValue(datePicker, forKey: "contentViewController")
  }

  public func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
    let action = UIAlertAction(title: title, style: style, handler: handler)
    action.isEnabled = isEnabled

    // button image
    if let image = image {
      action.setValue(image, forKey: "image")
    }

    // button title color
    if let color = color {
      action.setValue(color, forKey: "titleTextColor")
    }

    addAction(action)
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
