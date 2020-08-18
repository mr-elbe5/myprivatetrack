//
//  ImageViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: ModalScrollViewController {
    
    var imageData : ImageData? = nil
    
    override func loadView() {
        super.loadView()
        if let imageData = imageData{
            let imageView = UIImageView(image: imageData.getImage())
            scrollView.addSubview(imageView)
            imageView.fillSuperview()
        }
    }
    
}
