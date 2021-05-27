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
          // set today isDone status
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
//                            print(habit)
            }
        }
      }
  }
  func addNewHabit(habit: Habit, hours: [Int], minutes: [Int]) {
    let habits = db.collection("habits").document()
    let notification = db.collection("habits")
      .document(habits.documentID)
      .collection("notification")
      .document(currentUser)
    let data: [String: Any] = [
      "id": habits.documentID,
      "title": habit.title,
      "type": habit.type,
      "detail": habit.detail,
      "location": habit.location,
      "members": [currentUser],
      "icon": habit.icon,
      "slogan": habit.slogan,
      "owner": currentUser,
      "weekday": habit.weekday,
      "photo": habit.photo
    ]

    habits.setData(data)
    notification.setData(["hours": hours], merge: true)
    notification.setData(["minutes": minutes], merge: true)
  }

  func setAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    db.collection("habits")
      .whereField("members", arrayContains: currentUser)
      .getDocuments { querySnapshot, error in
        guard let documents = querySnapshot?.documents else {
          return
        }
        let habits = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        for habit in habits {
          // set notification
          for weekday in 1...7 {
            if habit.weekday[String(weekday)] == true {

              let notificationContent = UNMutableNotificationContent()
              notificationContent.title = habit.title
              notificationContent.body = habit.slogan
              notificationContent.badge = NSNumber(value: 1)
              notificationContent.sound = .default

              self.db.collection("habits")
                .document(habit.id)
                .collection("notification")
                .document(self.currentUser)
                .getDocument { documentSnapshot, error in
                  if let hours = documentSnapshot?.data()?["hours"] as? [Int],
                    let minutes = documentSnapshot?.data()?["minutes"] as? [Int],
                    !hours.isEmpty,
                    !minutes.isEmpty {
                    for i in 0...(hours.count - 1) {
                      var datComp = DateComponents()
                      datComp.weekday = weekday
                      datComp.hour = hours[i]
                      datComp.minute = minutes[i]

                      let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
                      let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
                      UNUserNotificationCenter.current().add(request) { error in
                        if let err = error {
                          print(err.localizedDescription)
                        }
                      }
                    }
                  }
                }
            }
          }
        }
      }
  }
}
