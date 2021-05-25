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
        let tempArray = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        // only show i am not a member
        self.publicHabits.value = []
        for element in tempArray {
          if !element.members.contains(HabitManager.shared.currentUser) {
            self.publicHabits.value.append(element)
          }
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
        let tempArray = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        // only show i am not a member
        self.publicHabits.value = []
        for element in tempArray {
          if !element.members.contains(HabitManager.shared.currentUser) {
            self.publicHabits.value.append(element)
          }
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
        let tempArray = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        // only show i am not a member
        self.publicHabits.value = []
        for element in tempArray {
          if !element.members.contains(HabitManager.shared.currentUser) {
            self.publicHabits.value.append(element)
          }
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
