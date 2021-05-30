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

  var location: String {
    return habit.location
  }

  var membersCount: Int {
    return habit.members.count
  }

  var members: [String] {
    return habit.members
  }

  var icon: String {
    return habit.icon
  }

  var photo: String {
    return habit.photo
  }

  var type: [String: Bool] {
    return habit.type
  }

}
