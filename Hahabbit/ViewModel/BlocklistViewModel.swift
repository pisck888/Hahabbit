//
//  BlacklistViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/4.
//

import Foundation

class BlocklistViewModel {

  var blockedUsersViewModel: Box<[User]> = Box([])

  var numberOfBlockedUsers: Int {
    return blockedUsersViewModel.value.count
  }

  func fetchBlockedUsers() {
    UserManager.shared.database
      .collection("users")
      .whereField("id", isEqualTo: UserManager.shared.currentUser)
      .addSnapshotListener { querySnapshot, error in
        if let err = error {
          print(err)
          return
        }
        if let currentUser = try? querySnapshot?.documents[0].data(as: User.self) {
          self.convertBlocklistToViewModel(blockList: currentUser.blocklist)
        }
      }
  }

  private func convertBlocklistToViewModel(blockList: [String]) {
    for blockedUser in blockList {
      UserManager.shared.database
        .collection("users")
        .whereField("id", isEqualTo: blockedUser)
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
