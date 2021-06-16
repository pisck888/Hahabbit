//
//  HomeViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/20.
//

import Foundation

class HomeViewModel {

  let habitViewModels = Box([HabitViewModel]())

  var refreshView: (() -> Void)?

  func onRefresh() {
    // maybe do something
    self.refreshView?()
  }

  func fetchData(type: Int = 0, weekday: Date = Date()) {
    HabitManager.shared.fetchHabits(type: type, date: weekday) { result in
      switch result {
      case .failure(let error):
        print("fetchData.failure: \(error)")
      case .success(let habits):
        self.convertHabitsToViewModels(from: habits)
      }
    }
  }

  func convertHabitsToViewModels(from habits: [Habit]) {
    var viewModels: [HabitViewModel] = []
    for habit in habits {
      let viewModel = HabitViewModel(model: habit)
      viewModels.append(viewModel)
    }
    habitViewModels.value = viewModels
  }
}
