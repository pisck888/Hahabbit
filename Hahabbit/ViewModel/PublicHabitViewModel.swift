//
//  PublicHabitViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/23.
//

import Foundation

class PublicHabitViewModel {

  var publicHabits: Box<[Habit]> = Box([])

  func fetchData() {
    HabitManager.shared.database
      .collection("habits")
      .whereField("type.1", isEqualTo: true)
      .getDocuments { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        let tempArray = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        // only show if current user is not in members
        self.publicHabits.value = []
        for element in tempArray {
          if !element.members.contains(UserManager.shared.currentUser) {
            self.publicHabits.value.append(element)
          }
        }

      }
  }

  func fetchData(withLocation location: String) {
    HabitManager.shared.database
      .collection("habits")
      .whereField("type.1", isEqualTo: true)
      .whereField("location", isEqualTo: location)
      .getDocuments { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        let tempArray = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        // only show i am not a member
        self.publicHabits.value = []
        for element in tempArray {
          if !element.members.contains(UserManager.shared.currentUser) {
            self.publicHabits.value.append(element)
          }
        }
      }
  }

  func fetchData(withType type: Int) {
    HabitManager.shared.database
      .collection("habits")
      .whereField("type.1", isEqualTo: true)
      .whereField("type.\(type)", isEqualTo: true)
      .getDocuments { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        let tempArray = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        // only show i am not a member
        self.publicHabits.value = []
        for element in tempArray {
          if !element.members.contains(UserManager.shared.currentUser) {
            self.publicHabits.value.append(element)
          }
        }
      }
  }

  func fetchData(withWeekday weekday: Int) {
    HabitManager.shared.database
      .collection("habits")
      .whereField("type.1", isEqualTo: true)
      .whereField("weekday.\(weekday)", isEqualTo: true)
      .getDocuments { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        let tempArray = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        // only show i am not a member
        self.publicHabits.value = []
        for element in tempArray {
          if !element.members.contains(UserManager.shared.currentUser) {
            self.publicHabits.value.append(element)
          }
        }
      }
  }
}
