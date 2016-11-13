//
//  Face.swift
//  FaceSwap
//
//  Created by Dariy Kordiyak on 11/13/16.
//  Copyright © 2016 Dariy Kordiyak. All rights reserved.
//

import Foundation
import UIKit

class Face {
    var image: UIImage
    var frame: CGRect
    
    init(image: UIImage, frame: CGRect) {
        self.image = image
        self.frame = frame
    }
}
