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
    private var imageFrames: [CGRect] = []
    
    // MARK: - User action
    
    @IBAction func pick(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func swap(_ sender: UIButton) {
        // detect all faces
        let facesFromImage = detectFaces()
        // swap faces randomly
        for face in facesFromImage {
            let randomFrameIndex = Int(arc4random_uniform(UInt32(imageFrames.count)))
            let randomFrame = imageFrames[randomFrameIndex]
            
            drawAbovePhotoIv(face, frame: randomFrame)
        }
    }
    
    // MARK: - Detection
    
    private func detectFaces() -> [UIImage] {
        var faces: [UIImage] = []
        
        let imageCI = CIImage(cgImage: photoIV.image!.cgImage!)
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])     // BSXPCMessage prevention
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        let features = detector?.features(in: imageCI, options: [CIDetectorImageOrientation: exif()])
        
        print("faces count: \(features?.count)")
        
        // for all faces
        for f in features as! [CIFaceFeature] {
            let faceRect = f.bounds
            imageFrames.append(faceRect)
            // crop them and save to image array
            let croppedImageRef = photoIV.image!.cgImage!.cropping(to: faceRect)
            let croppedImage: UIImage! = UIImage(cgImage: croppedImageRef!)
            
            faces.append(croppedImage!)
        }
        
        return faces
    }
    
    // MARK: - Swapping faces
    
    private func drawAbovePhotoIv(_ faceImage: UIImage, frame: CGRect) {
        UIGraphicsBeginImageContext(photoIV.image!.size)
        photoIV.image!.draw(in: CGRect(x: 0, y: 0, width: photoIV.image!.size.width, height: photoIV.image!.size.height))
        faceImage.draw(in: CGRect(x: photoIV.image!.size.width - faceImage.size.width, y: photoIV.image!.size.height - faceImage.size.height, width: faceImage.size.width, height: faceImage.size.height))
        let res = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.photoIV.image = res
        })
    }
    
    // MARK: - Helpers
    
    private func exif() -> Int {
        // handle image orientation
        var exifOrientation = 6
        switch (photoIV.image!.imageOrientation) {
        case .up:
            exifOrientation = 1
        case .down:
            exifOrientation = 3
        case .left:
            exifOrientation = 8
        case .right:
            exifOrientation = 6
        case .upMirrored:
            exifOrientation = 2
        case .downMirrored:
            exifOrientation = 4
        case .leftMirrored:
            exifOrientation = 5
        case .rightMirrored:
            exifOrientation = 7
        }
        
        return exifOrientation
    }
    
    // MARK: - Extensions
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.dismiss(animated: true, completion: nil)
        photoIV.image = image
    }
}

