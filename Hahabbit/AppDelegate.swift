//
//  AppDelegate.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    //    UINavigationBar.appearance().barTintColor = .systemGray6
    //    UINavigationBar.appearance().layer.borderWidth = 0
    //    UINavigationBar.appearance().clipsToBounds = true

    //    UITabBar.appearance().barTintColor = .black
    UITabBar.appearance().tintColor = .black
    // This is for removing top line from the tabbar.
    //    UITabBar.appearance().layer.borderWidth = 0.0
    //    UITabBar.appearance().clipsToBounds = true

    let image = UIImage(named: "arrowCircleLeft")
    UINavigationBar.appearance().backIndicatorImage = image
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
    UINavigationBar.appearance().tintColor = .black

    // setup IQKeyboard
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatPageViewController.self)

    // setup Firebase
    FirebaseApp.configure()

    // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge, .carPlay]) { granted, error in
        if granted {
          print("允許")
        } else {
          print("不允許")
        }
      }
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}
