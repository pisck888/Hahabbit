//
//  UICollectionView+Extension.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/21.
//

import UIKit

extension UICollectionView {
  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as? T else {
      return T()
    }
    return cell
  }
}
