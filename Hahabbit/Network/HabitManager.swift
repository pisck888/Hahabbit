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
//  let today = Date()
  var habits: [Habit] = []

  lazy var db = Firestore.firestore()

  func fetchTodayHabits(type: Int = 0, weekday: Date = Date(), completion: @escaping (Result<[Habit], Error>) -> Void) {

    let weekday = Calendar.current.component(.weekday, from: weekday)

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
              if documentSnapshot?.data()?["date" + today] == nil {
                self.db.collection("habits")
                  .document(habit.id)
                  .collection("isDone")
                  .document(self.currentUser)
                  .setData(["date" + today: false], merge: true)
              }
              print(habit.id, documentSnapshot?.data()?["date" + today])
            }
        }
      }
  }

//  func fetchIsDoneRecord(habitID: String) {
//
//    let date = Date()
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyyMMdd"
//    let today = formatter.string(from: date)
//    print("date" + today)
//
//    db.collection("habits")
//      .document(habitID)
//      .collection("isDone")
//      .document(currentUser)
//      .getDocument { documentSnapshot, _ in
//        
//      }
//  }

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
