/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

extension UIViewController: ImageItemDelegate, VideoItemDelegate{
    
    func viewImageItem(data: ImageItemData) {
        let photoViewController = ImageViewController()
        photoViewController.uiImage = data.getImage()
        photoViewController.modalPresentationStyle = .fullScreen
        self.present(photoViewController, animated: true)
    }
    
    func shareImageItem(data: ImageItemData) {
        let alertController = UIAlertController(title: title, message: "shareImage".localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "imageLibrary".localize(), style: .default) { action in
            FileController.copyImageToLibrary(name: data.fileName, fromDir: FileController.privateURL){ result in
                DispatchQueue.main.async {
                    switch result{
                    case .success:
                        self.showAlert(title: "success".localize(), text: "photoShared".localize())
                    case .failure(let err):
                        self.showAlert(title: "error".localize(), text: err.errorDescription!)
                    }
                }
            }
        })
        alertController.addAction(UIAlertAction(title: "ownDocuments".localize(), style: .default) { action in
            if FileController.copyFile(name: data.fileName, fromDir: FileController.privateURL, toDir: FileController.exportDirURL, replace: true){
                self.showAlert(title: "success".localize(), text: "photoShared".localize())
            }
            else{
                self.showAlert(title: "error".localize(), text: "copyError".localize())
            }
        })
        alertController.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func viewVideoItem(data: VideoItemData) {
        let videoViewController = VideoViewController()
        videoViewController.videoURL = data.fileURL
        videoViewController.modalPresentationStyle = .fullScreen
        self.present(videoViewController, animated: true)
    }
    
    func shareVideoItem(data: VideoItemData) {
        let alertController = UIAlertController(title: title, message: "shareImage".localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "imageLibrary".localize(), style: .default) { action in
            FileController.copyVideoToLibrary(name: data.fileName, fromDir: FileController.privateURL){ result in
                DispatchQueue.main.async {
                    switch result{
                    case .success:
                        self.showAlert(title: "success".localize(), text: "videoShared".localize())
                        return
                    case .failure(let err):
                        self.showAlert(title: "error".localize(), text: err.errorDescription!)
                    }
                }
            }
        })
        alertController.addAction(UIAlertAction(title: "ownDocuments".localize(), style: .default) { action in
            if FileController.copyFile(name: data.fileName, fromDir: FileController.privateURL, toDir: FileController.exportDirURL, replace: true){
                self.showAlert(title: "success".localize(), text: "videoShared".localize())
            }
            else{
                self.showAlert(title: "error".localize(), text: "copyError".localize())
            }
        })
        alertController.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
}
