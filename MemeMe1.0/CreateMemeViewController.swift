//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Tanvi Roy on 1/14/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class CreateMemeViewController:
UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var album: UIBarButtonItem!
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.white,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.delegate = self
        self.bottom.delegate = self
        self.top.text = "TOP"
        self.bottom.text = "BOTTOM"
        self.top.defaultTextAttributes = memeTextAttributes
        self.bottom.defaultTextAttributes = memeTextAttributes
        self.share.isEnabled = false
        self.top.textAlignment = NSTextAlignment.center
        self.bottom.textAlignment = NSTextAlignment.center
        NotificationCenter.default.addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        openImagePicker(UIImagePickerController.SourceType.camera)
    }
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        openImagePicker(UIImagePickerController.SourceType.savedPhotosAlbum)
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        setDefault()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            self.share.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottom.isEditing{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = textField.text;
        textField.text = "";
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count == 0) {
            textField.text = textField.placeholder;
        }
        textField.placeholder = "";
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        top.isHidden = true
        bottom.isHidden = true
        imageView.isHidden = true
        top.text = "TOP"
        bottom.text = "BOTTOM"
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let memed = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memed], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(memed)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func save(_ memedImage: UIImage) {
        let meme = Meme(topText: self.top.text!,
                        bottomText: self.bottom.text!,
                        originalImage: self.imageView.image!,
                        memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print(appDelegate.memes.count)
    }
    
    func hideToolBar(_ hide: Bool){
        self.navigationController?.navigationBar.isHidden = hide
        self.toolbar.isHidden = false
    }
    
    func generateMemedImage() -> UIImage {
        hideToolBar(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideToolBar(false)
        return memedImage
    }
    
    func setDefault(){
        self.top.text = "TOP"
        self.bottom.text = "BOTTOM"
        self.top.textAlignment = NSTextAlignment.center
        self.bottom.textAlignment = NSTextAlignment.center
        self.share.isEnabled = false
        imageView.image = nil
    }
}
