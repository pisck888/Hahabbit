//
//  ProfileViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/24.
//

import Foundation

class ProfileViewModel {

  var currentUser: Box<User?> = Box(nil)

  var tappedUser: Box<User?> = Box(nil)

  func fetchCurrentUser() {
    UserManager.shared.database
      .collection("users")
      .whereField("id", isEqualTo: UserManager.shared.currentUser)
      .addSnapshotListener { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        if let user = try? querySnapshot?.documents[0].data(as: User.self) {
          self.currentUser.value = user
        }
      }
  }

  func fetchTappedUser(id: String) {
    UserManager.shared.database
      .collection("users")
      .whereField("id", isEqualTo: id)
      .getDocuments { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        if let user = try? querySnapshot?.documents[0].data(as: User.self) {
          self.tappedUser.value = user
        }
      }
  }
}
