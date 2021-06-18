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

  let themeColorNumber = UserDefaults().value(forKey: "ThemeColorNumber") as? Int ?? 0

  var themeColor = ThemeColor.colorArray[UserDefaults().value(forKey: "ThemeColorNumber") as? Int ?? 0]

  var isHapticFeedback = UserDefaults().value(forKey: "IsHapticFeedback") as? Bool ?? false

  var currentUser = "pisck780527@gmail.com"
  var userSignUpDate = "20210101"

  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter
  }()

  lazy var db = Firestore.firestore()

  func signInUser(id: String, name: String) {
    let user = db.collection("users").document(id)
    let today = dateFormatter.string(from: Date())
    let userInfo: [String: Any] = [
      "id": id,
      "name": name,
      "image": "https://firebasestorage.googleapis.com/v0/b/hahabbit-8f194.appspot.com/o/userAvatars%2Fcat.png?alt=media&token=f42f5f23-1668-405b-805b-c144ee6574c3",
      "coin": 0,
      "title": "初心者",
      "signUpDate": today,
      "titleArray": ["初心者", "新來的", "煞氣a"],
      "blocklist": []
    ]

    UserManager.shared.db.collection("users")
      .whereField("id", isEqualTo: id)
      .getDocuments { querySnapshot, _ in
        guard let documents = querySnapshot?.documents else { return }
        if documents.isEmpty {
          user.setData(userInfo, merge: true)
          UserManager.shared.currentUser = id
        } else {
          UserManager.shared.currentUser = id
        }
      }
  }

  func fetchUserSignUpDate() {
    db.collection("users")
      .document(currentUser)
      .getDocument { documentSnapshot, error in
        if let error = error {
          print(error)
          return
        }
        if let date = documentSnapshot?.data()?["signUpDate"] as? String {
          self.userSignUpDate = date
        }
      }

  }

  func uploadAvatarImage(imageData: Data) {
    let storageRef = Storage.storage()
      .reference()
      .child("userAvatars")
      .child("\(currentUser).png")
    storageRef.putData(imageData, metadata: nil) { data, error in
      if let err = error {
        print(err)
        return
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
  func updateChatRoomName(newName: String) {
    HabitManager.shared.db
      .collection("chats")
      .whereField("members", arrayContains: UserManager.shared.currentUser)
      .getDocuments { querySnapshot, error in
        if let habits = querySnapshot?.documents {
          let habitIDs = habits.compactMap { $0["id"] }
          for habitID in habitIDs {
            HabitManager.shared.db
              .collection("chats")
              .document(habitID as! String)
              .collection("thread")
              .whereField("senderID", isEqualTo: UserManager.shared.currentUser)
              .getDocuments { querySnapshot, error in
                if let messages = querySnapshot?.documents {
                  let messageIDs = messages.compactMap { $0["id"] }
                  for messageID in messageIDs {
                    HabitManager.shared.db
                      .collection("chats")
                      .document(habitID as! String)
                      .collection("thread")
                      .document(messageID as! String)
                      .updateData(["senderName": newName])
                  }
                }
              }
          }
        }
      }
  }
  func updateName(newName: String) {
    db.collection("users")
      .document(currentUser)
      .updateData(["name": newName])
  }

  func updateTitle(newTitle: String) {
    db.collection("users")
      .document(currentUser)
      .updateData(["title": newTitle])
  }

  func updateCoin(newCoin: Int) {
    db.collection("users")
      .document(currentUser)
      .updateData(["coin": newCoin])
  }

  func blockUser(id: String) {
    db.collection("users")
      .document(currentUser)
      .updateData(["blocklist": FieldValue.arrayUnion([id])])
  }

  func unBlockUser(id: String) {
    db.collection("users")
      .document(currentUser)
      .updateData(["blocklist": FieldValue.arrayRemove([id])])
  }
}
