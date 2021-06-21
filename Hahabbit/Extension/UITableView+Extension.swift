//
//  UITableView+Extension.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/21.
//

import UIKit

extension UITableView {
  public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
      return T()
    }
    return cell
  }
}
