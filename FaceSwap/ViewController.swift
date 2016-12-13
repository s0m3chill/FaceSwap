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
        photoIV.image = UIImage(named: "test2.jpg")
        swap(UIButton())
    }
    
    @IBAction func swap(_ sender: UIButton) {
        // get 2 faces and draw them above photoIV
        let facesFromImage = FaceManager.shared.facesFrom(imageView: photoIV)
        
        let face0 = facesFromImage[0]
        let face1 = facesFromImage[1]
        var frame0 = face0.frame
        var frame1 = face1.frame
        
        if frame0.size.width > frame1.size.width {
            frame0.origin.x += frame0.size.width / 2
            frame1.origin.y -= frame1.size.height / 2
        } else {
            frame0.origin.x += frame0.size.width / 2
            frame1.origin.y -= frame1.size.height / 2
        }
        
        let frame0Size = frame0.size
        frame0.size = frame1.size
        frame1.size = frame0Size
        
        drawAbovePhotoIv(face0.image, frame: frame0)
        drawAbovePhotoIv(face1.image, frame: frame1)
    }
    
//    private func faceFrame(_ face: Face) -> CGRect {
//        var faceViewBounds = face.frame
//        
//        let ciImageSize = CIImage(image: photoIV.image!)!.extent.size
//        let viewSize = photoIV.bounds.size
//        let scale = min(viewSize.width / ciImageSize.width,
//                        viewSize.height / ciImageSize.height)
//        let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
//        let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
//        
//        //faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
//        faceViewBounds.origin.x += offsetX
//        faceViewBounds.origin.y += offsetY
//        
//        return faceViewBounds
//    }
    
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

