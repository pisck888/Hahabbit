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

  var userViewModel: Box<User> = Box(User(id: "", title: "", name: "", image: "", coin: 0, email: "", titleArray: []))

  func fetchData() {
    UserManager.shared.db
      .collection("users")
      .whereField("id", isEqualTo: UserManager.shared.currentUser)
      .addSnapshotListener { querySnapshot, error in
        if let user = try? querySnapshot?.documents[0].data(as: User.self) {
          self.userViewModel.value = user
        }
      }
  }
}
