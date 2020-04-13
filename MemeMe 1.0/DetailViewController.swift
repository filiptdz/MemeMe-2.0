//
//  DetailViewController.swift
//  MemeMe 1.0
//
//  Created by Filipe Degrazia on 03/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  var image: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
  }
  
}
