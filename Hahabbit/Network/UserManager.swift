//
//  UserManager.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/28.
//

import Foundation
import Firebase

class UserManager {
  static let shared = UserManager()

  var currentUser = "pisck780527@gmail.com"

  lazy var db = Firestore.firestore()

  func signInUser(id: String, name: String, email: String) {
    let user = db.collection("users").document(id)
    let userInfo: [String: Any] = [
      "id": id,
      "name": name,
      "email": email,
      "image": "",
      "coin": 0,
      "title": "菜逼",
      "titleArray": []
    ]

    UserManager.shared.db.collection("users")
      .whereField("id", isEqualTo: id)
      .getDocuments { querySnapshot, _ in
        let documents = querySnapshot?.documents
        if documents == [] {
          user.setData(userInfo, merge: true)
          HabitManager.shared.currentUser = id
          UserManager.shared.currentUser = id
        } else {
          HabitManager.shared.currentUser = id
          UserManager.shared.currentUser = id
        }
      }
  }

  func uploadAvatarImage(imageData: Data) {
    let uniqueString = UUID().uuidString
    let storageRef = Storage.storage().reference()
      .child("userAvatars")
      .child("\(uniqueString).png")
    storageRef.putData(imageData, metadata: nil) { data, error in
      if let err = error {
        print(err.localizedDescription)
      } else {
        storageRef.downloadURL { url, error in
          guard let url = url, error == nil else {
            print(error)
            return
          }
          self.db.collection("users").document(self.currentUser).updateData(["image": url.absoluteString])
        }
      }
    }
  }
  func updateName(newName: String) {
    db.collection("users").document(currentUser)
      .updateData(["name": newName])
  }

  func updateTitle(newTitle: String) {
    db.collection("users").document(currentUser)
      .updateData(["title": newTitle])
  }
}
