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
    
    @IBOutlet var navbar: UINavigationBar!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    // MARK: Properties
    
    var meme = Meme()
    let imagePicker = UIImagePickerController()
    let topTextFieldDelegate = TextFieldDelegate(defaultText: "TOP")
    let bottomTextFieldDelegate = TextFieldDelegate(defaultText: "BOTTOM")
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!,
        .foregroundColor: UIColor.white,
        .strokeColor: UIColor.black,
        .strokeWidth: -3.0
    ]
    
    // MARK: Computed Properties
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    var deviceHasCamera: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    var updatingMeme: Bool {
        return meme.id != nil
    }
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        // Disallow the user to dismiss the editor if there are no memes.
        if memes.isEmpty {
            cancelButton.isEnabled = false
            cancelButton.tintColor = .clear
        }
        
        // Disable the done button until an image is selected.
        if !updatingMeme {
            doneButton.isEnabled = false
        }
        
        // Setup both text fields.
        setupTextField(topTextField, delegate: topTextFieldDelegate)
        setupTextField(bottomTextField, delegate: bottomTextFieldDelegate)
        
        // Allow the image view to be tapped to change the image.
        setupImageView(imageView)
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
    
    func setupImageView(_ imageView: UIImageView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImagePickerSourceTypeActionSheet))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if updatingMeme {
            guard let i = appDelegate.memes.index(where: { $0.id == meme.id }) else { return }
            appDelegate.memes[i].topText = topTextField.text!
            appDelegate.memes[i].bottomText = bottomTextField.text!
            appDelegate.memes[i].originalImage = imageView.image!
            appDelegate.memes[i].memedImage = generateMemedImage()
        } else {
            meme.topText = topTextField.text!
            meme.bottomText = bottomTextField.text!
            meme.originalImage = imageView.image!
            meme.memedImage = generateMemedImage()
            meme.id = appDelegate.memes.count + 1
            
            appDelegate.memes.insert(meme, at: 0)
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
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
    
    @IBAction func presentImagePickerSourceTypeActionSheet() {
        if !deviceHasCamera {
            presentImagePicker(sourceType: .photoLibrary)
            return
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Choose From Photo Library", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme() {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityView.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityView, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        save()
        dismiss(animated: true, completion: nil)
    }
}
