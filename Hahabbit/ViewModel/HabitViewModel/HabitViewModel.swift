//
//  HabitViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/20.
//

import Foundation

class HabitViewModel {

  var habit: Habit

  init(model habit: Habit) {
    self.habit = habit
  }

  var id: String {
    return habit.id
  }

  var title: String {
    return habit.title
  }

  var slogan: String {
    return habit.slogan
  }

  var detail: String {
    return habit.detail
  }

  var weekday: [String: Bool] {
    return habit.weekday
  }

}
