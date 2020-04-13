//
//  Meme.swift
//  MemeMe 1.0
//
//  Created by Filipe Degrazia on 29/02/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
  static var updatedMemeListNotification = Notification.Name("updatedMemeList")
  var top: String?
  var bottom: String?
  var initialImage: UIImage?
  var finalImage: UIImage?
}
