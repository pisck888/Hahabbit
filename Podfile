# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'Hahabbit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Hahabbit
  pod 'SwiftLint'

  # for set image
  pod 'Kingfisher', '~> 6.0'

  # for firebase
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'FirebaseFirestoreSwift'

  # for keyboard
  pod 'IQKeyboardManagerSwift'

  # for segmented control
  pod 'PinterestSegment'

  # for calendar
  pod 'FSCalendar'

  # for charts
  pod 'ScrollableGraphView'
  pod 'MBCircularProgressBar'

  # for DropDown
  pod 'ContextMenuSwift'

  # for AlertController
  pod 'CustomizableActionSheet'

  # for chat room
  pod 'MessageKit'

  # for pull to refresh
  pod 'MJRefresh'

  # for popup View
  pod 'PopupDialog', '~> 1.1'

  # for animations
  pod 'lottie-ios'

  # for ProgressHUD
  pod 'JGProgressHUD'

  # for localization
  pod 'Localize-Swift', '~> 3.2'

  # for collectionView
  pod 'Blueprints'

  # for theme color
  pod 'SwiftTheme'
  pod 'SwiftHEXColors'

end

target 'HahabbitTests' do
    inherit! :search_paths
    pod 'Firebase'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end
end
