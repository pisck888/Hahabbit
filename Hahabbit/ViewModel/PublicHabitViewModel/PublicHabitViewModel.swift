//
//  PublicHabitViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class PublicHabitViewModel {

  var publicHabits: Box<[Habit]> = Box([])

  func fetchData() {
    HabitManager.shared.db
      .collection("habits")
      .whereField("type.1", isEqualTo: true)
      .getDocuments { querySnapshot, error in
        guard error == nil else {
          print("There was an issue retrieving data from Firebase. \(error)")
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        self.publicHabits.value = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
      }
  }

  func fetchData(withLocation location: String) {
    HabitManager.shared.db
      .collection("habits")
      .whereField("type.1", isEqualTo: true)
      .whereField("location", isEqualTo: location)
      .getDocuments { querySnapshot, error in
        guard error == nil else {
          print("There was an issue retrieving data from Firebase. \(error)")
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        self.publicHabits.value = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
      }
  }

  func fetchData(withType type: Int) {
    HabitManager.shared.db
      .collection("habits")
      .whereField("type.\(type)", isEqualTo: true)
      .getDocuments { querySnapshot, error in
        guard error == nil else {
          print("There was an issue retrieving data from Firebase. \(error)")
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        self.publicHabits.value = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
      }
  }
}

//class PublicHabitViewModelTest {
//
//  var publicHabit: Habit
//  var ownerInfo: User
//
//  init(habit: Habit, ownerInfo: User) {
//    self.publicHabit = habit
//    self.ownerInfo = ownerInfo
//  }
//}
