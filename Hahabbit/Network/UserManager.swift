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
      "image": "",
      "coin": 0,
      "title": "菜逼",
      "signUpDate": today,
      "titleArray": [],
      "blacklist": []
    ]

    UserManager.shared.db.collection("users")
      .whereField("id", isEqualTo: id)
      .getDocuments { querySnapshot, _ in
        let documents = querySnapshot?.documents
        if documents == [] {
          user.setData(userInfo, merge: true)
          UserManager.shared.currentUser = id
        } else {
          UserManager.shared.currentUser = id
        }
      }
  }

  func fetchUserSignUpDate(completionHandler: @escaping () -> Void) {
    db.collection("users")
      .document(currentUser)
      .getDocument { documentSnapshot, error in
        if let error = error {
          print(error)
          return
        }
        if let date = documentSnapshot?.data()?["signUpDate"] as? String {
          self.userSignUpDate = date
          completionHandler()
        }
      }

  }

  func uploadAvatarImage(imageData: Data) {
    let storageRef = Storage.storage().reference()
      .child("userAvatars")
      .child("\(currentUser).png")
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
      .updateData(["blacklist": FieldValue.arrayUnion([id])])
  }

  func unBlockUser(id: String) {
    db.collection("users")
      .document(currentUser)
      .updateData(["blacklist": FieldValue.arrayRemove([id])])
  }


}
