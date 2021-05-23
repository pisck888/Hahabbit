//
//  File.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum FirebaseError: Error {
  case documentError
}

class HabitManager {
  static let shared = HabitManager()

  let currentUser = "pisck780527@gmail.com"

  var habits: [Habit] = []

  lazy var db = Firestore.firestore()

  func fetchHabits(type: Int = 0, date: Date = Date(), completion: @escaping (Result<[Habit], Error>) -> Void) {

    let weekday = Calendar.current.component(.weekday, from: date)

    db.collection("habits")
      .whereField("members", arrayContains: currentUser)
      .whereField("weekday.\(weekday)", isEqualTo: true)
      .whereField("type.\(type)", isEqualTo: true)
      .getDocuments { querySnapshot, error in
        guard error == nil else {
          completion(.failure(error!))
          print("There was an issue retrieving data from Firebase. \(error!)")
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        self.habits = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        completion(.success(self.habits))

        for habit in self.habits {
          let date = Date()
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyyMMdd"
          let today = formatter.string(from: date)

          self.db.collection("habits")
            .document(habit.id)
            .collection("isDone")
            .document(self.currentUser)
            .getDocument { documentSnapshot, _ in
              if documentSnapshot?.data()?[today] == nil {
                self.db.collection("habits")
                  .document(habit.id)
                  .collection("isDone")
                  .document(self.currentUser)
                  .setData([today: false], merge: true)
              }
//              print(habit)
            }
        }
      }
  }
//  func addNewHabit(title: String, type: Int, detail: String, slogan: String) {
//    let habits = db.collection("tsetHabits").document()
//    let data: [String: Any] = [
//      "id": habits.documentID,
//      "title": title,
//      "type": type,
//      "detail": detail,
//      "icon": "",
//      "isCompleted": false,
//      "isDone": false,
//      "slogan": slogan,
//      "userID": "pisck780527@gmail.com"
//    ]
//    habits.setData(data)
//  }
}
