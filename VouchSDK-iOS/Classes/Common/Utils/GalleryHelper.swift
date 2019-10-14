//
//  GalleryHelper.swift
//  Vouch
//
//  Created by Ajie Pramono Arganata on 12/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIKit
import Photos

internal class GalleryHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private static var delegate = GalleryHelper()
    private var onChooseImageAction: ((_ image: UIImage, _ file: String, _ url: String)->())?
    
    //Show alert
    internal static func openDialogGallery(from rootVC: UIViewController, onChooseImageAction: ((_ image: UIImage, _ file: String, _ url: String)->())?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = rootVC.view
            popoverController.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            GalleryHelper.getImage(from: rootVC, fromSourceType: .camera, onChooseImageAction: onChooseImageAction)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            GalleryHelper.getImage(from: rootVC, fromSourceType: .photoLibrary, onChooseImageAction: onChooseImageAction)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        rootVC.present(alert, animated: true, completion: nil)
    }
    
    //get image from source type
    private static func getImage(from rootVC: UIViewController, fromSourceType sourceType: UIImagePickerController.SourceType, onChooseImageAction: ((_ image: UIImage, _ file: String, _ url: String)->())?) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self.delegate
            self.delegate.onChooseImageAction = onChooseImageAction
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            rootVC.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.onChooseImageAction?(image, getFileName(info: info).0, getFileName(info: info).1)
        picker.dismiss(animated: true, completion: nil)
    }

    func getFileName(info: [UIImagePickerController.InfoKey : Any]) -> (String, String) {
        if let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [assetPath], options: nil)
            let asset = result.firstObject
//            let fileName = asset?.value(forKey: "filename")
//            let fileUrl = URL(string: fileName as! String)
            var sonu = ""
//            if let name = fileUrl?.deletingPathExtension().lastPathComponent {
//                print(name)
                //let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
                if (assetPath.absoluteString.hasSuffix("JPG")) {
                    sonu = "JPG"
                    print("JPG")
                }
                else if (assetPath.absoluteString.hasSuffix("PNG")) {
                    sonu = "PNG"
                    print("PNG")
                }
                else if (assetPath.absoluteString.hasSuffix("GIF")) {
//                    sonu = "GIF"
                    print("GIF")
                }
                else {
                    sonu = "Unknown"
                    print("Unknown")
                }
                
                return (sonu, assetPath.absoluteString)
//            }
        }
        return ("", "")
    }
}
