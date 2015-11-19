//
//  ViewController.swift
//  Meme
//
//  Created by Katherine Ebel on 11/15/15.
//  Copyright © 2015 Katherine Ebel. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var activityButton: UIBarButtonItem!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var toolBar: UIToolbar!
  
  
  var activeTextField: UITextField!
  var imagePicker = UIImagePickerController()
  var meme: Meme!
  var memedImage: UIImage!
  let memeTextAttributes = [
    NSStrokeColorAttributeName: UIColor.blackColor(),
    NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
    NSStrokeWidthAttributeName: -1.0]
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    imagePicker.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    configureTextFields()
    subscribeToKeyboardNotifications()
    
  }
  
  override func viewWillDisappear(animated: Bool) {
    unsubscribeToKeyboardNotifications()
  }
  
  func configureTextFields() {
    let topString = NSMutableAttributedString(string: "TOP", attributes: memeTextAttributes)
    let bottomString = NSMutableAttributedString(string: "Bottom", attributes: memeTextAttributes)
    let textfields = [topTextField, bottomTextField]
    for textfield in textfields {
      textfield.textAlignment = .Center
    }
    topTextField.attributedText = topString
    bottomTextField.attributedText = bottomString
  }
  
  // MARK: Notifications
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }

  func keyboardWillShow(notification: NSNotification) {
    if activeTextField != nil {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if activeTextField != nil {
      view.frame.origin.y += getKeyboardHeight(notification)
    }
  }
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func unsubscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  // MARK: Generate and save meme
  
  func generateMemedImage() -> UIImage {
    navigationBar.hidden = true
    toolBar.hidden = true
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.imageView.frame, afterScreenUpdates: true)
    let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return memedImage
  }
  
  func saveMeme() {
    meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image, memedImage: memedImage)
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    appDelegate.memes.append(meme)
  }
  
  // MARK: Actions

  @IBAction func pickAnImage(sender: UIBarButtonItem) {
    presentViewController(imagePicker, animated: true, completion: nil)
  }

  @IBAction func share(sender: UIBarButtonItem) {
    
      memedImage = generateMemedImage()
      let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
    presentViewController(activityViewController, animated: true, completion: nil)
    activityViewController.completionWithItemsHandler = {completion in
      self.saveMeme()
      self.toolBar.hidden = false
      self.navigationBar.hidden = false
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }

}

// MARK: Extensions
extension EditMemeViewController: UINavigationControllerDelegate {
  
}

extension EditMemeViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    activityButton.enabled = true
    
    if let image = info[UIImagePickerControllerOriginalImage] {
      self.imageView.image = image as? UIImage
    } else if let image = info[UIImagePickerControllerEditedImage] {
      imageView.image = image as? UIImage
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension EditMemeViewController: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let oldtext = textField.text! as NSString
    let newText = oldtext.stringByReplacingCharactersInRange(range, withString: string)
    textField.text = newText.capitalizedString
    return false
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField == bottomTextField {
      if activeTextField == nil {
        activeTextField = textField
      }
    }
    switch textField {
    case topTextField:
      textField.text! = "TOP"
    case bottomTextField:
      textField.text! = "BOTTOM"
      
    default:
      textField.text! = ""
    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    activeTextField = nil
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}