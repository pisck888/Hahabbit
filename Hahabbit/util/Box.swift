//
//  Box.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/20.
//

import Foundation

final class Box<T> {

  typealias Listener = (T) -> Void

  var listener: Listener?

  var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }

  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
