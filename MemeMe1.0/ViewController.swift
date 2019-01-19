//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Tanvi Roy on 1/14/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class ViewController:
UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var top: UITextField!    
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.white,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  3.0
    ]
    
    struct Meme {
        let topText : String?
        let bottomText : String?
        let originalImage: UIImage?
        let memedImage: UIImage?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.top.delegate = self
        self.bottom.delegate = self
        self.top.defaultTextAttributes = memeTextAttributes
        self.bottom.defaultTextAttributes = memeTextAttributes
        self.top.text = "TOP"
        self.bottom.text = "BOTTOM"
        self.top.textAlignment = NSTextAlignment.center
        self.bottom.textAlignment = NSTextAlignment.center
        self.share.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)){
            camera.isEnabled = false
        }

    }
    
    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        self.share.isEnabled = true
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
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("testing")
        return true
    }
    
    @IBAction func cancel(_ sender: Any) {
        imageView.image = nil
        self.top.text = "TOP"
        self.bottom.text = "BOTTOM"
        self.top.textAlignment = NSTextAlignment.center
        self.bottom.textAlignment = NSTextAlignment.center
        self.share.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let memed = generateMemedImage()
        let img: UIImage = memed
        let shareItems:Array = [img]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self.save(memedImage : memed)
            if !completed {
                return
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }

    func save(memedImage : UIImage) {
        let meme = Meme(
                    topText: self.top.text!,
                    bottomText: self.bottom.text!,
                    originalImage: self.imageView.image!,
                    memedImage: memedImage
        )
    }
    
    func hideNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
        self.toolbar.isHidden = true
    }
    
    func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.toolbar.isHidden = false
    }
    
    func generateMemedImage() -> UIImage {
        hideNavigationBar()
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        showNavigationBar()
        return memedImage
    }
}
