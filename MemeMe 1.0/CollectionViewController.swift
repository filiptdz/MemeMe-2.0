//
//  CollectionViewController.swift
//  MemeMe 1.0
//
//  Created by Filipe Degrazia on 02/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class CollectionViewController: ListNavigationViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
  
  let spacing: CGFloat = 3.0

  var memes: [Meme] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.memes
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    
    updateLayoutItemSize(screenSize: view.frame.size)
    
    collectionFlowLayout.minimumInteritemSpacing = spacing
    collectionFlowLayout.minimumLineSpacing = spacing
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateCollectionData()
    NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionData), name: Meme.updatedMemeListNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: Meme.updatedMemeListNotification, object: nil)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    updateLayoutItemSize(screenSize: size)
  }
  
  @objc func updateCollectionData() {
    collectionView.reloadData()
  }
  
  func updateLayoutItemSize(screenSize: CGSize) {
    let size: CGFloat!
    if screenSize.height < screenSize.width {
      size = (screenSize.width - (5 - 1) * spacing) / 6.0
    } else {
      size = (screenSize.width - (3 - 1) * spacing) / 3.0
    }
    collectionFlowLayout.itemSize = CGSize(width: size, height: size)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
    cell.imageView.image = memes[indexPath.row].finalImage
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    detailController.image = memes[indexPath.row].finalImage
    navigationController?.pushViewController(detailController, animated: true)
  }
}
