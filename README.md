# Hahabbit [<img src = "Images/appIcon.png" width="40" align=left>](https://apps.apple.com/tw/app/hahabbit/id1571439855)[<img src = "Images/app_store_icon.jpeg" width = "140" align=right>](https://apps.apple.com/tw/app/hahabbit/id1571439855)
[![MIT license](https://img.shields.io/badge/License-MIT-green)](/LICENSE)
[![Language](https://img.shields.io/badge/Language-swift5-orange)](https://developer.apple.com/swift)
![Platform](https://img.shields.io/badge/Platform-iOS13.4%2B-blue)
[![Release](https://img.shields.io/badge/Release-v1.0.4-yellow)](https://apps.apple.com/tw/app/hahabbit/id1571439855)

>幫助你培養好習慣的最佳助手！

`Hahabbit` 是一個幫助您培養習慣與記錄每日習慣執行狀況的好幫手，也可以透過此 App 認識其他想培養相同習慣的使用者或是與其他使用者們分享培養習慣的心得。

>如果想要下載並於 Xcode 內運行此專案，請自行於 Google Firebase 上創建新的專案並下載 GoogleService-Info.plist 加入專案內，另外因部分第三方套件尚未支援 M1 晶片，使用 M1 晶片的電腦可能無法成功運行。


## Features & ScreenShots
- 記錄每日習慣執行狀況，自動產生圖表輔助你了解習慣的執行狀況  
  
    <kbd><img src = "Images/mainPage.gif" width="200" align=center>
    
- 新增習慣並設定提醒時間，讓 App 於你指定的時間發出通知提醒你該完成習慣  

    <kbd><img src = "Images/addNewHabit.gif" width="200" align=center></kbd>　<kbd><img src = "Images/notification.gif" width="200" align=center></kbd>
    
- 遊戲化的成就系統，增加使用者完成習慣的動力  
    
    <kbd><img src = "Images/Achievements.gif" width="200" align=center>
    
- 搜尋其他使用者的公開習慣，加入一起執行  
    
    <kbd><img src = "Images/publicHabits.gif" width="200" align=center>
    
- 可於公開習慣內的多人聊天室一同分享習慣的執行心得，進而認識更多想培養相同習慣的其他使用者  
    
    <kbd><img src = "Images/chatroom.gif" width="200" align=center>
    
- 可在 App 內自由設定語言、主題色彩等等  
   
    <kbd><img src = "Images/changeLanguage.gif" width="200" align=center></kbd>　<kbd><img src = "Images/changeColor.gif" width="200" align=center></kbd>

## Libraries  
- [Firebase](https://github.com/firebase/firebase-ios-sdk)
   - Auth - 驗證用戶註冊與登入資訊，提供登入與登出功能
   - Storage - 儲存用戶上傳的個人照片與習慣照片
   - Firestore - 儲存與管理所有用戶個人資料、習慣細節與聊天對話紀錄等資料
   - Crashlytics - 掌握 App 的 Crash 報告，以提供錯誤修復及效能改善
- [Kingfisher](https://github.com/onevcat/Kingfisher) - 善用快取的方式處理網路圖片並呈現在 App
- [FSCalendar](https://github.com/WenchaoD/FSCalendar) - 客製化月曆外觀，並以月曆呈現每日不同的習慣列表
- [PinterestSegment](https://github.com/TBXark/PinterestSegment) - 呈現類似 Pinterest 樣式的 Segmented Control 讓使用者可以快速搜尋不同分類的習慣
- [ContextMenuSwift](https://github.com/umerjabbar/ContextMenuSwift) - 呈現動態的 Context Menu 讓使用者可以以不同條件搜尋習慣
- [CustomizableActionSheet](https://github.com/beryu/CustomizableActionSheet) - 呈現可自定義畫面與內容的 Action Sheet
- [MessageKit](https://github.com/MessageKit/MessageKit) - 用來快速建置一個多人聊天室
- [SwiftLint](https://github.com/realm/SwiftLint) - 檢查 Coding Style 增進程式碼品質
- [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) - 解決鍵盤彈出時遮住輸入框或畫面內容的問題
- [ScrollableGraphView](https://github.com/philackm/ScrollableGraphView) - 呈現曲線趨勢圖表
- [MBCircularProgressBar](https://github.com/MatiBot/MBCircularProgressBar)- 呈現圓餅圖表
- [Lottie-ios](https://github.com/airbnb/lottie-ios) - 呈現動畫效果
- [MJRefresh](https://github.com/CoderMJLee/MJRefresh) - 提供下拉更新功能
- [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD) - 顯示上傳完成等各種狀態的提示窗
- [PopupDialog](https://github.com/Orderella/PopupDialog) - 客製化各種訊息提示視窗
- [SwiftTheme](https://github.com/wxxsw/SwiftTheme) - 提供直接在 App 內轉換主題顏色的功能
- [Localize-Swift](https://github.com/marmelroy/Localize-Swift) - 提供直接在 App 內轉換介面語言的功能  
- [SwiftHEXColors](https://github.com/thii/SwiftHEXColors) - 處理 HEX Color 的顏色轉換

## Languages
- 繁體中文
- 英文
      
## Requirements

- **iOS 13.4** or later
- **Xcode 12** or later

## Version History

- 1.0.4 - 2021/06/27 - 抓了幾隻臭蟲
- 1.0.3 - 2021/06/22 - 優化某些 UI 顯示方式，抓了幾隻臭蟲
- 1.0.2 - 2021/06/16 - 新增更換主題顏色功能
- 1.0.1 - 2021/06/14 - 新增語言切換功能  
- 1.0.0 - 2021/06/12 - 第一個上架版本
 
## License
      
[![MIT license](https://img.shields.io/badge/License-MIT-green)](/LICENSE)
      
## Contacts

Max Tsai  
Email: pisck780527@gmail.com
