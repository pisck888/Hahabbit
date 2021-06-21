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

  var habits: [Habit] = []

  lazy var database = Firestore.firestore()

  func fetchHabits(type: Int = 0, date: Date = Date(), completion: @escaping (Result<[Habit], Error>) -> Void) {

    let weekday = Calendar.current.component(.weekday, from: date)

    database.collection("habits")
      .whereField("members", arrayContains: UserManager.shared.currentUser)
      .whereField("weekday.\(weekday)", isEqualTo: true)
      .whereField("type.\(type)", isEqualTo: true)
      .getDocuments { querySnapshot, error in
        if let err = error {
          completion(.failure(err))
          print("There was an issue retrieving data from Firebase. \(err)")
          return
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        self.habits = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        self.initHabitsTodayRecord(habits: self.habits)
        completion(.success(self.habits))
      }
  }

  func initHabitsTodayRecord(habits: [Habit]) {
    for habit in habits {
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyyMMdd"
      let today = formatter.string(from: date)
      // set today isDone status
      self.database.collection("habits")
        .document(habit.id)
        .collection("isDone")
        .document(UserManager.shared.currentUser)
        .getDocument { documentSnapshot, _ in
          if documentSnapshot?.data()?[today] == nil {
            self.database.collection("habits")
              .document(habit.id)
              .collection("isDone")
              .document(UserManager.shared.currentUser)
              .setData([today: false], merge: true)
          }
        }
    }
  }

  func fetchAllHabits(completion: @escaping (Result<[Habit], Error>) -> Void) {
    database.collection("habits")
      .whereField("members", arrayContains: UserManager.shared.currentUser)
      .addSnapshotListener { querySnapshot, error in
        if let err = error {
          completion(.failure(err))
        }
        guard let documents = querySnapshot?.documents else {
          return
        }
        self.habits = documents.compactMap { queryDocumentSnapshot in
          try?  queryDocumentSnapshot.data(as: Habit.self)
        }
        completion(.success(self.habits))
      }
  }

  func uploadHabit(habit: Habit, hours: [Int], minutes: [Int], completionHandler: ((String) -> Void)?) {
    if habit.id.isEmpty {
      let newHabitRef = database.collection("habits").document()
      let notification = database.collection("habits")
        .document(newHabitRef.documentID)
        .collection("notification")
        .document(UserManager.shared.currentUser)
      let data: [String: Any] = [
        "id": newHabitRef.documentID,
        "title": habit.title,
        "type": habit.type,
        "detail": habit.detail,
        "location": habit.location,
        "members": [UserManager.shared.currentUser],
        "icon": habit.icon,
        "slogan": habit.slogan,
        "owner": UserManager.shared.currentUser,
        "weekday": habit.weekday,
        "photo": habit.photo
      ]
      newHabitRef.setData(data)
      notification.setData(["hours": hours], merge: true)
      notification.setData(["minutes": minutes], merge: true)
      completionHandler?(newHabitRef.documentID)
    } else {
      let editHabitRef = database.collection("habits").document(habit.id)
      let notification = database.collection("habits")
        .document(habit.id)
        .collection("notification")
        .document(UserManager.shared.currentUser)
      let data: [String: Any] = [
        "id": habit.id,
        "title": habit.title,
        "type": habit.type,
        "detail": habit.detail,
        "location": habit.location,
        "members": [UserManager.shared.currentUser],
        "icon": habit.icon,
        "slogan": habit.slogan,
        "owner": UserManager.shared.currentUser,
        "weekday": habit.weekday,
        "photo": habit.photo
      ]
      notification.setData(["hours": hours], merge: true)
      notification.setData(["minutes": minutes], merge: true)
      editHabitRef.setData(data) { error in
        if let err = error {
          print(err)
          return
        }
        completionHandler?(habit.id)
      }
    }

  }

  func deleteHabit(habit: Habit) {
    if habit.owner == UserManager.shared.currentUser {
      database.collection("habits")
        .document(habit.id)
        .delete { error in
          if let err = error {
            print(err)
            return
          }
        }
      database.collection("chats")
        .document(habit.id)
        .delete { error in
          if let err = error {
            print(err)
            return
          }
        }
      let storage = Storage.storage()
      let storageRef = storage.reference(forURL: habit.photo)
      storageRef.delete { error in
        if let err = error {
          print(err)
          return
        }
      }
    } else {
      database.collection("habits")
        .document(habit.id)
        .updateData([
          "members": FieldValue.arrayRemove([UserManager.shared.currentUser])
        ]) { error in
          if let err = error {
            print(err)
            return
          }
        }
      database.collection("chats")
        .document(habit.id)
        .updateData([
          "members": FieldValue.arrayRemove([UserManager.shared.currentUser])
        ]) { error in
          if let err = error {
            print(err)
            return
          }
        }
    }
  }

  func setAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    database.collection("habits")
      .whereField("members", arrayContains: UserManager.shared.currentUser)
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
              notificationContent.badge = 1
              notificationContent.sound = .default

              guard
                let imageURL = Bundle.main.url(forResource: "catPlaceholder", withExtension: "png"),
                let attachment = try? UNNotificationAttachment(identifier: "image", url: imageURL, options: nil) else {
                return
              }
              notificationContent.attachments = [attachment]

              self.database.collection("habits")
                .document(habit.id)
                .collection("notification")
                .document(UserManager.shared.currentUser)
                .getDocument { documentSnapshot, error in
                  guard
                    let hours = documentSnapshot?.data()?["hours"] as? [Int],
                    let minutes = documentSnapshot?.data()?["minutes"] as? [Int],
                    !hours.isEmpty,
                    !minutes.isEmpty
                  else {
                    return
                  }
                  for i in 0...(hours.count - 1) {
                    var datComp = DateComponents()
                    datComp.weekday = weekday
                    datComp.hour = hours[i]
                    datComp.minute = minutes[i]

                    let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
                    let request = UNNotificationRequest(
                      identifier: UUID().uuidString,
                      content: notificationContent,
                      trigger: trigger
                    )
                    UNUserNotificationCenter.current().add(request) { error in
                      if let err = error {
                        print(err)
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
