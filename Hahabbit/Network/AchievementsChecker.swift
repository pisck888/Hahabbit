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

  lazy var db = Firestore.firestore()

  //  var achievement = Achievement(id: 0, type: 0, reward: 0, title: "", discription: "", requirement: 0, isDone: [])

  func checkAllAchievements(checked: Bool) {
    guard checked == false else { return }
    checkAchievements1()

  }

  func checkAchievements0() {

  }
  // 半夜睡不著覺
  func checkAchievements1() {

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"

    let timeString = dateFormatter.string(from: Date())

    if timeString == "02" {
      db.collection("achievements")
        .whereField("id", isEqualTo: 1)
        .whereField("isDone", arrayContains: UserManager.shared.currentUser)
        .getDocuments { querySnapshot, error in
          guard error == nil else {
            print(error)
            return
          }
          guard let documents = querySnapshot?.documents else { return }
          if documents.isEmpty {
            print("獲得成就")
            self.db.collection("achievements")
              .document("1")
              .updateData(["isDone": FieldValue.arrayUnion([UserManager.shared.currentUser])]
              )
            self.db.collection("achievements")
              .document("1")
              .getDocument { documentSnapshot, error in
                guard error == nil else {
                  print(error)
                  return
                }
                if let achievement = try? documentSnapshot?.data(as: Achievement.self) {
                  self.db.collection("users")
                    .document(UserManager.shared.currentUser)
                    .getDocument { documentSnapshot, error in
                      guard error == nil else {
                        print(error)
                        return
                      }
                      if let coin = documentSnapshot?.data()?["coin"] as? Int {
                        let newCoin = coin + achievement.reward
                        UserManager.shared.updateCoin(newCoin: newCoin)
                        self.delegate?.showPopupView(title: achievement.title, message: achievement.discription, image: achievement.image)
                      }
                    }
                }
              }
          } else {
            print("已獲得該成就")
            return
          }
        }
    }
  }
}
