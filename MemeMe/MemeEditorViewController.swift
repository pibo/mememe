//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Felipe Ribeiro on 09/10/18.
//  Copyright © 2018 Felipe Ribeiro. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var navbar: UIToolbar!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    // MARK: Properties
    
    let imagePicker = UIImagePickerController()
    let topTextFieldDelegate = TextFieldDelegate(defaultText: "TOP")
    let bottomTextFieldDelegate = TextFieldDelegate(defaultText: "BOTTOM")
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!,
        .foregroundColor: UIColor.white,
        .strokeColor: UIColor.black,
        .strokeWidth: -3.0
    ]
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupTextField(topTextField, delegate: topTextFieldDelegate)
        setupTextField(bottomTextField, delegate: bottomTextFieldDelegate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Helper Methods
    
    func setupTextField(_ textField: UITextField, delegate: TextFieldDelegate) {
        textField.delegate = delegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        textField.text = delegate.defaultText
    }
    
    func generateMemedImage() -> UIImage {
        toggleBars()
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toggleBars()
        
        return memedImage
    }
    
    func toggleBars() {
        navbar.isHidden.toggle()
        toolbar.isHidden.toggle()
    }
    
    func save() {
        // Create a meme instance.
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imageView.image!,
            memedImage: generateMemedImage()
        )
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: Keyboard Related Methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            return keyboardSize.cgRectValue.height
        }
        
        return 0.0
    }
    
    // MARK: Actions
    
    @IBAction func pickImageFromCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme() {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityView.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.save()
            }
            
            return
        }
        
        present(activityView, animated: true, completion: nil)
    }
    
    @IBAction func newMeme() {
        imageView.image = nil
        topTextField.text = topTextFieldDelegate.defaultText
        bottomTextField.text = bottomTextFieldDelegate.defaultText
        shareButton.isEnabled = false
    }
}
