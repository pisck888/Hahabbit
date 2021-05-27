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
      .getDocuments { querySnapshot, error in

        guard let documents = querySnapshot?.documents else {
          return
        }

        self.allAchievements = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Achievement.self)
        }

        for achievement in self.allAchievements {
          if achievement.isDone.contains(HabitManager.shared.currentUser) {
            self.userAchievements.value.append(achievement)
          } else if achievement.type == 0 {
            self.dailyAchievements.value.append(achievement)
          } else {
            self.specialAchievements.value.append(achievement)
          }
        }
      }
  }


  //  init(model achievement: Achievement) {
  //    self.achievement = achievement
  //  }

}

