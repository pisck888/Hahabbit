//
//  AchievementViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/25.
//

import Foundation
import FirebaseFirestoreSwift

class AchievementViewModel {

  var allAchievements: [Achievement] = []

  var userAchievements: Box<[Achievement]> = Box([])

  var dailyAchievements: Box<[Achievement]> = Box([])

  var specialAchievements: Box<[Achievement]> = Box([])


  func fetchData() {
    HabitManager.shared.db.collection("achievements")
      .addSnapshotListener { querySnapshot, error in
        if let err = error {
          print(err)
        }

        guard let documents = querySnapshot?.documents else {
          return
        }

        self.allAchievements = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Achievement.self)
        }
        self.userAchievements.value.removeAll()
        self.dailyAchievements.value.removeAll()
        self.specialAchievements.value.removeAll()

        for achievement in self.allAchievements {
          if achievement.isDone.contains(UserManager.shared.currentUser) {
            self.userAchievements.value.append(achievement)
          } else if achievement.type == 0 {
            self.dailyAchievements.value.append(achievement)
          } else {
            self.specialAchievements.value.append(achievement)
          }
        }
      }
  }
}
