//
//  Utils.swift
//  FaceSwap
//
//  Created by Dariy Kordiyak on 11/13/16.
//  Copyright © 2016 Dariy Kordiyak. All rights reserved.
//

import UIKit

class Utils {
    
    static let shared = Utils()
    private init() {}
    
    func facesFrom(imageView: UIImageView) -> [Face] {
        var faces: [Face] = []
        
        guard let photo = CIImage(image: imageView.image!) else { return [] }
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])     // BSXPCMessage prevention
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        let features = detector?.features(in: photo, options: [CIDetectorImageOrientation: Utils.shared.exif(fromImageView: imageView)])
        
        let ciImageSize = photo.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        print("faces count: \(features?.count)")
        
        // for all faces
        for face in features as! [CIFaceFeature] {
            let faceViewBounds = face.bounds.applying(transform)
            
            // crop them and save to image array
            let croppedImageRef = imageView.image!.cgImage!.cropping(to: faceViewBounds)
            let croppedImage: UIImage! = UIImage(cgImage: croppedImageRef!).rotated(by: 180)
            
            faces.append(Face(image: croppedImage, frame: faceViewBounds))
        }
        
        return faces
    }
    
    func exif(fromImageView imageView: UIImageView) -> Int {
        var exifOrientation = 6
        switch (imageView.image!.imageOrientation) {
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

}
