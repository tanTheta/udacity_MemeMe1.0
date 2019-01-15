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
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var top: UITextField!
    
    let memeTextAttributes: [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue:  3.0
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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)){
            camera.isEnabled = false
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.share.isEnabled = true
    }
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true, completion: nil)
        
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
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
    
    @IBAction func cancel(_ sender: Any) {
        imageView.image = nil
        self.top.text = "TOP"
        self.bottom.text = "BOTTOM"
        self.top.textAlignment = NSTextAlignment.center
        self.bottom.textAlignment = NSTextAlignment.center
        self.share.isEnabled = false
    }
    
    @IBAction func shareImage(_ sender: Any) {
        // Create the meme
        print("ready to share")

        var memed = generateMemedImage()
        var img: UIImage = memed
        //var shareItems:Array = [img, messageStr]
        var shareItems:Array = [img]
        print("here")
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            let meme = Meme(topText: self.top.text!, bottomText: self.bottom.text!, originalImage: self.imageView.image!, memedImage: memed)
            if !completed {
                return
            }
        }
        self.present(activityViewController, animated: true, completion: nil)


    }
    func save(memed : UIImage) {
        // Create the meme
    }
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
}
