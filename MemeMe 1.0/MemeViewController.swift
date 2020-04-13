//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Filipe Degrazia on 28/02/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var topLabel: UITextField!
  @IBOutlet weak var bottomLabel: UITextField!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var topToolbar: UIToolbar!
  @IBOutlet weak var bottomToolbar: UIToolbar!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  
  enum TextFieldTag: Int {
    case top = 0, bottom
  }
  
  let labelStyles: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.strokeColor: UIColor.black,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSAttributedString.Key.strokeWidth: -5,
  ]
  
  func getPlaceholderText(_ string: String) -> NSAttributedString {
    return NSAttributedString(string: string, attributes: labelStyles)
  }
  
  func configureTextField(_ field: UITextField, placeholderText: String) {
    field.defaultTextAttributes = labelStyles
    field.attributedPlaceholder = getPlaceholderText(placeholderText)
    field.textAlignment = .center
    field.delegate = self
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureTextField(topLabel, placeholderText: "TOP TEXT")
    configureTextField(bottomLabel, placeholderText: "BOTTOM TEXT")
    
    shareButton.isEnabled = false
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    
    subscribeToKeyboard()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeToKeyboard()
  }
  
  var meme = Meme()
  var savedMeme: Meme?
  
  func updateMeme(top: String? = nil, bottom: String? = nil, initialImage: UIImage? = nil) {
    if let top = top {
      meme.top = top
    }
    if let bottom = bottom {
      meme.bottom = bottom
    }
    if let initialImage = initialImage {
      meme.initialImage = initialImage
      imageView.image = initialImage
    }
    if meme.top != nil && meme.bottom != nil && meme.initialImage != nil {
      shareButton.isEnabled = true
    }
  }
  
  func resetMeme() {
    meme = Meme()
    imageView.image = nil
    topLabel.text = nil
    bottomLabel.text = nil
    shareButton.isEnabled = false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    switch TextFieldTag(rawValue: textField.tag) {
    case .top:
      updateMeme(top: textField.text!)
    case .bottom:
      updateMeme(bottom: textField.text!)
    case .none:
      break
    }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      updateMeme(initialImage: image)
    }
    dismiss(animated: true, completion: nil)
  }
  
  func generateMemeImage() -> UIImage {
    topToolbar.isHidden = true
    bottomToolbar.isHidden = true
    
    UIGraphicsBeginImageContext(self.view.frame.size)
    view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    topToolbar.isHidden = false
    bottomToolbar.isHidden = false
    
    return finalImage
  }
  
  func getKeyboardHeight(_ notification: Notification) -> CGFloat {
    var keyboardHeight: CGFloat = 0.0
    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      keyboardHeight = keyboardRectangle.height
    }
    return keyboardHeight
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if bottomLabel.isEditing {
      view.frame.origin.y = -getKeyboardHeight(notification)
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    view.frame.origin.y = 0
  }
  
  func subscribeToKeyboard() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func unsubscribeToKeyboard() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func saveMeme() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.memes.append(self.meme)
    NotificationCenter.default.post(Notification(name: Meme.updatedMemeListNotification))
  }

  @IBAction func onPressShare(_ sender: Any) {
    let finalImage = generateMemeImage()
    meme.finalImage = finalImage
    let activityView = UIActivityViewController(activityItems: [finalImage], applicationActivities: nil)
    activityView.popoverPresentationController?.sourceView = self.view
    activityView.completionWithItemsHandler = { activity, success, items, error in
      if success {
        self.saveMeme()
      }
    }
    present(activityView, animated: true, completion: nil)
  }
  
  @IBAction func onPressCancel(_ sender: Any) {
    resetMeme()
    dismiss(animated: true)
  }
  
  func getImage(from source: UIImagePickerController.SourceType) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.sourceType = source
    present(pickerController, animated: true, completion: nil)
  }
  
  @IBAction func onPressCamera(_ sender: Any) {
    getImage(from: .camera)
  }
  
  @IBAction func onPressAlbum(_ sender: Any) {
    getImage(from: .photoLibrary)
  }
}

