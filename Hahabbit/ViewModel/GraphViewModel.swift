//
//  GraphViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/23.
//

import Foundation
import ScrollableGraphView

class GraphViewModel {
  var counter = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] {
    didSet {
      yearDoneDays = counter.reduce(0, +)
    }
  }
  var monthRecord: Box<Int> = Box(0)
  var monthDoneDays = 0 {
    didSet {
      let month = Calendar.current.component(.month, from: Date())
      switch month {
      case 1, 3, 5, 7, 8, 10, 12:
        monthPercentage.value = (CGFloat(monthDoneDays) / CGFloat(31)) * 100
      case 2:
        monthPercentage.value = (CGFloat(monthDoneDays) / CGFloat(28)) * 100
      default:
        monthPercentage.value = (CGFloat(monthDoneDays) / CGFloat(30)) * 100
      }
    }
  }
  var yearDoneDays = 0 {
    didSet {
      yearPercentage.value = (CGFloat(yearDoneDays) / CGFloat(365)) * 100
    }
  }
  var monthPercentage: Box<CGFloat> = Box(0)
  var yearPercentage: Box<CGFloat> = Box(0)
  var totalRecord: Box<Int> = Box(0)
  var consecutiveRecordArray: [Bool] = []
  var consecutiveRecord: Box<Int> = Box(0)

  func fetchGraphData(graphView: ScrollableGraphView, habitID: String) {
    let year = Calendar.current.component(.year, from: Date())
    HabitManager.shared.db
      .collection("habits")
      .document(habitID)
      .collection("isDone")
      .document(UserManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard error == nil else {
          print(error as Any)
          return
        }
        guard let keys = documentSnapshot?.data()?.keys else { return }
        // count GraphViewNumbers
        self.counter = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for key in keys {
          if documentSnapshot?.data()?[key] as! Bool == true {
            guard let date = Int(key) else { return }
            switch date {
            case (year * 10000 + 101) ... (year * 10000 + 131):
              self.counter[0] += 1
            case (year * 10000 + 201) ... (year * 10000 + 231):
              self.counter[1] += 1
            case (year * 10000 + 301) ... (year * 10000 + 331):
              self.counter[2] += 1
            case (year * 10000 + 401) ... (year * 10000 + 431):
              self.counter[3] += 1
            case (year * 10000 + 501) ... (year * 10000 + 531):
              self.counter[4] += 1
            case (year * 10000 + 601) ... (year * 10000 + 631):
              self.counter[5] += 1
            case (year * 10000 + 701) ... (year * 10000 + 731):
              self.counter[6] += 1
            case (year * 10000 + 801) ... (year * 10000 + 831):
              self.counter[7] += 1
            case (year * 10000 + 901) ... (year * 10000 + 931):
              self.counter[8] += 1
            case (year * 10000 + 1001) ... (year * 10000 + 1031):
              self.counter[9] += 1
            case (year * 10000 + 1101) ... (year * 10000 + 1131):
              self.counter[10] += 1
            case (year * 10000 + 1201) ... (year * 10000 + 1231):
              self.counter[11] += 1
            default:
              print("data might be wrong!")
            }
          }
        }
        graphView.reload()
      }
  }


  func fetchRecordData(habitID: String) {

    let year = Calendar.current.component(.year, from: Date())
    let month = Calendar.current.component(.month, from: Date())

    self.monthRecord.value = 0
    self.totalRecord.value = 0
    self.consecutiveRecord.value = 0
    self.monthDoneDays = 0

    HabitManager.shared.db
      .collection("habits")
      .document(habitID)
      .collection("isDone")
      .document(UserManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard error == nil else {
          print(error as Any)
          return
        }
        guard let keys = documentSnapshot?.data()?.keys else { return }
        guard let values = documentSnapshot?.data()?.values else { return }

        // get consecutiveRecord
        for i in 0 ... keys.count - 1 {
          let date = String(keys.sorted()[i])
          self.consecutiveRecordArray.append(documentSnapshot?.data()?[date] as! Bool)
        }
        self.consecutiveRecord.value = self.findMaxConsecutiveTrue(array: self.consecutiveRecordArray)

        for value in values where value as! Bool == true {
          // count totalRecord
          self.totalRecord.value += 1
        }

        for key in keys {
          guard let date = Int(key) else { return }
          switch date {
          case (year * 10000) + (month * 100) ... (year * 10000) + (month * 100) + 31:
            // count monthRecord
            if documentSnapshot?.data()?[String(date)] as! Bool == true {
              self.monthRecord.value += 1
              // count monthPercentage
              self.monthDoneDays += 1
            }
          default:
            break
          }
        }
      }
  }

  func findMaxConsecutiveTrue(array: [Bool]) -> Int {
    var result = 0
    var counter = 0

    for element in array {
      counter += element == true ? 1 : 0
      counter = element == false ? 0 : counter
      result = counter < result ? result : counter
    }
    return result
  }
}
