//
//  TableViewController.swift
//  MemeMe 1.0
//
//  Created by Filipe Degrazia on 02/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class TableViewController: ListNavigationViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  
  var memes: [Meme]! {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.memes
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTableData()
    NotificationCenter.default.addObserver(self, selector: #selector(updateTableData), name: Meme.updatedMemeListNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: Meme.updatedMemeListNotification, object: nil)
  }
  
  @objc func updateTableData() {
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
    let meme = memes[indexPath.row]
    cell.imageView?.image = meme.finalImage
    cell.textLabel?.text = "\(meme.top!) \(meme.bottom!)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    detailController.image = memes[indexPath.row].finalImage
    navigationController?.pushViewController(detailController, animated: true)
  }
}
