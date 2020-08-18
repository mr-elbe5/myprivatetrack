//
//  ImageViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: ModalScrollViewController, UIScrollViewDelegate {
    
    var imageData : ImageData? = nil
    var imageView : UIImageView? = nil
    
    override func loadView() {
        super.loadView()
        if let imageData = imageData{
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            imageView = UIImageView(image: imageData.getImage())
            imageView!.contentMode = .scaleAspectFit
            imageView!.isUserInteractionEnabled = true
            scrollView.addSubview(imageView!)
            imageView!.fillSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if imageView != nil && imageView!.image != nil{
            let minWidthScale = scrollView.bounds.width / imageView!.image!.size.width
            let minHeightScale = scrollView.bounds.height / imageView!.image!.size.height
            scrollView.minimumZoomScale = min(minWidthScale,minHeightScale)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
