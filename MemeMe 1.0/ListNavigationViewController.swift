//
//  ListNavigationViewController.swift
//  MemeMe 1.0
//
//  Created by Filipe Degrazia on 03/03/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class ListNavigationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewMeme))
    }
    
    @objc func addNewMeme() {
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
}
