//
//  File.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol HabitManagerDelegate: AnyObject {
  func setNewData(data: Habit)
}

enum FirebaseError: Error {
  case documentError
}

class HabitManager {
  static let shared = HabitManager()

  weak var delegate: HabitManagerDelegate?

  var habits: [Habit] = []

  lazy var db = Firestore.firestore()

  func fetchHabits(type: Int = 0, date: Date = Date(), completion: @escaping (Result<[Habit], Error>) -> Void) {

    let weekday = Calendar.current.component(.weekday, from: date)

    db.collection("habits")
      .whereField("members", arrayContains: UserManager.shared.currentUser)
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
            .document(UserManager.shared.currentUser)
            .getDocument { documentSnapshot, _ in
              if documentSnapshot?.data()?[today] == nil {
                self.db.collection("habits")
                  .document(habit.id)
                  .collection("isDone")
                  .document(UserManager.shared.currentUser)
                  .setData([today: false], merge: true)
              }
            }
        }
      }
  }
  func uploadHabit(habit: Habit, hours: [Int], minutes: [Int]) {
    if habit.id == "" {
      let newHabitRef = db.collection("habits").document()
      let notification = db.collection("habits")
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
    } else {
      let editHabitRef = db.collection("habits").document(habit.id)
      let notification = db.collection("habits")
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
        guard error == nil else {
          print(error)
          return
        }
        self.delegate?.setNewData(data: habit)
      }
    }

  }

  func deleteHabit(habit: Habit) {
    if habit.owner == UserManager.shared.currentUser {
      db.collection("habits")
        .document(habit.id)
        .delete { error in
          guard error == nil else {
            print(error)
            return
          }
        }
    } else {
      db.collection("habits")
        .document(habit.id)
        .updateData([
          "members": FieldValue.arrayRemove([UserManager.shared.currentUser])
        ]) { error in
          guard error == nil else {
            print(error)
            return
          }
        }
    }
  }

    func deleteHabit(id: String) {
      db.collection("habits")
        .document(id)
        .delete { error in
          guard error == nil else {
            print(error)
            return
          }
        }
    }

    func fetchNotifications(id: String) {
      db.collection("habits")
        .document(id)
        .collection("notification")
        .document(UserManager.shared.currentUser)
        .getDocument { documentSnapshot, error in
          print(documentSnapshot?.data())
        }
    }

    func setAllNotifications() {
      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
      db.collection("habits")
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

                let imageURL = Bundle.main.url(forResource: "crocodile", withExtension: "png")!
                let attachment = try! UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
                notificationContent.attachments = [attachment]

                self.db.collection("habits")
                  .document(habit.id)
                  .collection("notification")
                  .document(UserManager.shared.currentUser)
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
