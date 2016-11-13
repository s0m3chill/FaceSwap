//
//  ViewController.swift
//  FaceSwap
//
//  Created by Dariy Kordiyak on 7/8/15.
//  Copyright (c) 2015 Dariy Kordiyak. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet weak var photoIV: UIImageView!
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // stub
        photoIV.image = UIImage(named: "test.jpg")
        swap(UIButton())
    }
    
    @IBAction func swap(_ sender: UIButton) {
        // get 2 faces and draw them above photoIV
        let facesFromImage = FaceManager.shared.facesFrom(imageView: photoIV)
        
        let face0 = facesFromImage[0]   // Darko
        let face1 = facesFromImage[1]   // Max
        
        var frame0 = face0.frame
        var frame1 = face1.frame
        
        print("0:  \(frame0),    1: \(frame1)")
        
        let image0 = face0.image
        let image1 = face1.image
        
        let frame0Size = frame0.size
        frame0.size = frame1.size
        frame1.size = frame0Size
        
        drawAbovePhotoIv(image0, frame: frame0)
        drawAbovePhotoIv(image1, frame: frame1)
    }
    
    private func faceFrame(_ face: Face) -> CGRect {
        var faceViewBounds = face.frame
        
        let ciImageSize = CIImage(image: photoIV.image!)!.extent.size
        let viewSize = photoIV.bounds.size
        let scale = min(viewSize.width / ciImageSize.width,
                        viewSize.height / ciImageSize.height)
        let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
        let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
        
        //faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
        faceViewBounds.origin.x += offsetX
        faceViewBounds.origin.y += offsetY
        
        return faceViewBounds
    }
    
    private func drawAbovePhotoIv(_ faceImage: UIImage, frame: CGRect) {
        UIGraphicsBeginImageContext(photoIV.image!.size)
        
        photoIV.image!.draw(in: CGRect(x: 0, y: 0, width: photoIV.image!.size.width, height: photoIV.image!.size.height))
        faceImage.draw(in: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
        let res = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        photoIV.image = res
    }
    
    // MARK: - Image picker
        
    @IBAction func pick(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Extensions
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.dismiss(animated: true, completion: nil)
        photoIV.image = image
    }
}

