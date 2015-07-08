//
//  ViewController.swift
//  FaceSwap
//
//  Created by Dariy Kordiyak on 7/8/15.
//  Copyright (c) 2015 Dariy Kordiyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photoIV: UIImageView!
    var imagePicker = UIImagePickerController()
    
    // MARK: - User action
    
    @IBAction func pick(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            presentViewController(imagePicker, animated: true , completion: nil)
        }
    }

    @IBAction func swap(sender: UIButton) {
       
    }
    
    // MARK: - Extensions
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        photoIV.image = image
    }
}

