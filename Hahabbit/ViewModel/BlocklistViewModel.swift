//
//  BlacklistViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/4.
//

import Foundation
import Firebase

class BlocklistViewModel {

  var blockedUsersViewModel: Box<[User]> = Box([])

  func fetchBlockedUsers(blockedUsers: [String]) {
    for user in blockedUsers {
      Firestore.firestore()
        .collection("users")
        .whereField("id", isEqualTo: user)
        .addSnapshotListener { querySnapshot, error in
          if let err = error {
            print(err)
          }
          if let user = try? querySnapshot?.documents[0].data(as: User.self) {
            if !self.blockedUsersViewModel.value.contains(user) {
              self.blockedUsersViewModel.value.append(user)
            }
          }
        }
    }
  }
}
