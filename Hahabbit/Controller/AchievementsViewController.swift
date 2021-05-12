//
//  AchievementsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit
import DisplaySwitcher

class AchievementsViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!

  private let animationDuration: TimeInterval = 0.3
  private let listLayoutStaticCellHeight: CGFloat = 80
  private let gridLayoutStaticCellHeight: CGFloat = 165

  private lazy var listLayout = DisplaySwitchLayout(
    staticCellHeight: listLayoutStaticCellHeight,
    nextLayoutStaticCellHeight: gridLayoutStaticCellHeight,
    layoutState: .list)

  private lazy var gridLayout = DisplaySwitchLayout(
    staticCellHeight: gridLayoutStaticCellHeight,
    nextLayoutStaticCellHeight: listLayoutStaticCellHeight,
    layoutState: .grid)

  private var layoutState: LayoutState = .list


  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.collectionViewLayout = listLayout
  }
}

extension AchievementsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    return cell
  }
}

extension AchievementsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
    let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    return customTransitionLayout
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath)
  }
}
