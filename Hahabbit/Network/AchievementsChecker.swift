//
//  AchievementsChecker.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/25.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AchievementsCheckerDelegate: AnyObject {
  func showPopupView(title: String, message: String, image: String)
}

class AchievementsChecker {

  static let checker = AchievementsChecker()

  weak var delegate: AchievementsCheckerDelegate?

  lazy var database = Firestore.firestore()

  func checkAllAchievements(checked: Bool) {
    guard checked == false else { return }
    checkAchievements0()
    checkAchievements1()
  }

  // 一馬當先
  func checkAchievements0() {
    let achievementID = 2
    database.collection("achievements")
      .whereField("id", isEqualTo: achievementID)
      .whereField("isDone", arrayContains: UserManager.shared.currentUser)
      .getDocuments { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        guard let documents = querySnapshot?.documents else { return }
        if documents.isEmpty {
          print("獲得成就2")
          self.database.collection("achievements")
            .document("2")
            .updateData(["isDone": FieldValue.arrayUnion([UserManager.shared.currentUser])]
            )
          self.addRewardToUserCurrentCoin(from: achievementID)
        } else {
          print("已獲得成就2")
          return
        }
      }

  }
  // 半夜睡不著覺
  func checkAchievements1() {
    let achievementID = 1

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"

    let timeString = dateFormatter.string(from: Date())

    if timeString == "02" {
      database.collection("achievements")
        .whereField("id", isEqualTo: achievementID)
        .whereField("isDone", arrayContains: UserManager.shared.currentUser)
        .getDocuments { querySnapshot, error in
          if let err = error {
            print(err)
            return
          }
          guard let documents = querySnapshot?.documents else { return }
          if documents.isEmpty {
            print("獲得成就1")
            self.database.collection("achievements")
              .document("1")
              .updateData(["isDone": FieldValue.arrayUnion([UserManager.shared.currentUser])]
              )
            self.addRewardToUserCurrentCoin(from: achievementID)
          } else {
            print("已獲得成就1")
            return
          }
        }
    }
  }

  func addRewardToUserCurrentCoin(from achievementID: Int) {
    self.database.collection("achievements")
      .document(String(achievementID))
      .getDocument { documentSnapshot, error in
        if let err = error {
          print(err)
          return
        }
        if let achievement = try? documentSnapshot?.data(as: Achievement.self) {
          self.updateUserCoinAndShowPopup(from: achievement)        }
      }
  }

  func updateUserCoinAndShowPopup(from achievement: Achievement) {
    database.collection("users")
      .document(UserManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        if let err = error {
          print(err)
          return
        }
        if let currentCoin = documentSnapshot?.data()?["coin"] as? Int {
          let newCoin = currentCoin + achievement.reward
          UserManager.shared.updateCoin(newCoin: newCoin)
          self.delegate?.showPopupView(
            title: achievement.title,
            message: achievement.discription,
            image: achievement.image
          )
        }
      }

  }
}
