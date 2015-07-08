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
    var imagePicker = UIImagePickerController()
    var imageFrames: [CGRect] = []
    
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
        // detect all faces
        var facesFromImage = detectFaces()
        // swap faces randomly
        for face in facesFromImage {
            let randomFrameIndex = Int(arc4random_uniform(UInt32(imageFrames.count)))
            let randomFrame = imageFrames[randomFrameIndex]
            
            // may be slow
            drawAbovePhotoIv(face, frame: randomFrame)
        }
    }
    
    // MARK: - Detection
    
    func detectFaces() -> [UIImage] {
        var faces: [UIImage] = []
       
        // handle image orientation
        var exifOrientation = 6
        switch (photoIV.image!.imageOrientation) {
        case .Up:
            exifOrientation = 1
            break;
        case .Down:
            exifOrientation = 3;
            break;
        case .Left:
            exifOrientation = 8;
            break;
        case .Right:
            exifOrientation = 6;
            break;
        case .UpMirrored:
            exifOrientation = 2;
            break;
        case .DownMirrored:
            exifOrientation = 4;
            break;
        case .LeftMirrored:
            exifOrientation = 5;
            break;
        case .RightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
        }
       
        var imageCI = CIImage(CGImage: photoIV.image!.CGImage)
        var context = CIContext(options: [kCIContextUseSoftwareRenderer: true])     // BSXPCMessage prevention
        var options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        var detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        var features = detector.featuresInImage(imageCI, options: [CIDetectorImageOrientation: exifOrientation])
        
        println("faces count: \(features.count)")
        
        // for all faces
        for f in features as! [CIFaceFeature] {
            var faceRect = f.bounds
            imageFrames.append(faceRect)
            // crop them and save to image array
            var croppedImageRef = CGImageCreateWithImageInRect(photoIV.image!.CGImage, faceRect)
            var croppedImage: UIImage! = UIImage(CGImage: croppedImageRef)
            
            faces.append(croppedImage!)
        }
        
        return faces
    }
    
    // MARK: - Swapping faces
    
    func drawAbovePhotoIv(faceImage: UIImage, frame: CGRect) {
        UIGraphicsBeginImageContext(photoIV.image!.size)
        photoIV.image!.drawInRect(CGRectMake(0, 0, photoIV.image!.size.width, photoIV.image!.size.height))
        faceImage.drawInRect(CGRectMake(photoIV.image!.size.width - faceImage.size.width, photoIV.image!.size.height - faceImage.size.height, faceImage.size.width, faceImage.size.height))
        let res = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.photoIV.image = res
        })
    }
    
    // MARK: - Extensions
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        photoIV.image = image
    }
}

