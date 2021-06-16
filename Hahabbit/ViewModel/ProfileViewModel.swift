//
//  ProfileViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ProfileViewModel {

  var currentUserViewModel: Box<User> = Box(User(id: "", title: "", name: "", image: "", coin: 0, signUpDate: "", titleArray: [], blacklist: []))

  var tappedUserViewModel: Box<User?> = Box(nil)

  func fetchCurrentUser() {
    UserManager.shared.db
      .collection("users")
      .whereField("id", isEqualTo: UserManager.shared.currentUser)
      .addSnapshotListener { querySnapshot, error in
        guard error == nil else {
          print(error)
          return
        }
        if let user = try? querySnapshot?.documents[0].data(as: User.self) {
          self.currentUserViewModel.value = user
        }
      }
  }

  func fetchTappedUser(id: String) {
    UserManager.shared.db
      .collection("users")
      .whereField("id", isEqualTo: id)
      .getDocuments { querySnapshot, error in
        guard error == nil else {
          print(error)
          return
        }
        if let user = try? querySnapshot?.documents[0].data(as: User.self) {
          self.tappedUserViewModel.value = user
        }
      }
  }
}
