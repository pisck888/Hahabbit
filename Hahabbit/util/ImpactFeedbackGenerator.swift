//
//  ImpactFeedbackGenerator.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/7/9.
//

import UIKit

enum ImpactFeedbackGenerator {
  private static let generator = UIImpactFeedbackGenerator(style: .light)
  static func impactOccurred() {
    if UserManager.shared.isHapticFeedback {
      generator.impactOccurred()
    }
  }
}
