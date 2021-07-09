//
//  ThemeColorViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/12.
//

import UIKit
import Blueprints
import SwiftTheme

class ThemeColorViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!

  let userDefault = UserDefaults()

  let blueprintLayout = VerticalBlueprintLayout(
    itemsPerRow: 5,
    height: (UIScreen.main.bounds.width - 96) / 5,
    minimumInteritemSpacing: 16,
    minimumLineSpacing: 16,
    sectionInset: EdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
    stickyHeaders: true,
    stickyFooters: false
  )

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "主題顏色".localized()

    collectionView.collectionViewLayout = blueprintLayout
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.selectItem(
      at: [0, userDefault.value(forKey: "ThemeColorNumber") as? Int ?? 0],
      animated: true,
      scrollPosition: []
    )
  }
}

extension ThemeColorViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    ThemeColor.colorArray.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ColorCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.setup(color: ThemeColor.colorArray[indexPath.row])
    return cell
  }
}

extension ThemeColorViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
      cell.selectedImage.alpha = 1
      userDefault.setValue(indexPath.row, forKey: "ThemeColorNumber")
      ThemeManager.setTheme(index: indexPath.row)
      UserManager.shared.themeColor = ThemeColor.colorArray[indexPath.row]
      NotificationCenter.default.post(name: NSNotification.Name("ChangeThemeColor"), object: nil)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
      cell.selectedImage.alpha = 0
    }
  }
}
