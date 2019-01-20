//
//  PhotoPickerController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 21/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import CoreServices

protocol PhotoPickerDelegate: class {
    
    func photoPicker(picker: PhotoPickerController, didSelectImage image: UIImage)
}

class PhotoPickerController: NSObject
{
    var alertController: UIAlertController?
    weak var buttonToPresentPopoverForiPad: UIButton?
    weak var viewController: UIViewController?
    lazy var pickerController = UIImagePickerController()
    var imagePickerDelegate: PhotoPickerDelegate?
    
    init(buttonToPresentPopoverForiPad button: UIButton, viewControllerToPresent viewController: UIViewController, imagePickerDelegate : PhotoPickerDelegate) {
        
        super.init()
        
        self.alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        self.buttonToPresentPopoverForiPad = button
        self.viewController = viewController
        self.imagePickerDelegate = imagePickerDelegate
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.alertController?.dismiss(animated: false, completion: nil)
        }
        
        alertController?.addAction(cancelAction)
        
        let photoAlbumAction = UIAlertAction(title: "Choose from Photo Library", style: .default) { (action) in
            self.selectPicture(pickerType: .photoLibrary)
        }
        
        alertController?.addAction(photoAlbumAction)
        
        let cameraAction = UIAlertAction(title: "Choose from Camera", style: .default) { (action) -> Void in
            self.selectPicture(pickerType: .camera)
        }
        
        alertController?.addAction(cameraAction)
        
        alertController?.modalPresentationStyle = .popover
        if UIDevice.current.userInterfaceIdiom == .pad {
            let popOverPresenter = alertController?.popoverPresentationController
            popOverPresenter?.sourceView = self.buttonToPresentPopoverForiPad
            popOverPresenter?.sourceRect = (self.viewController?.view.bounds)!
            popOverPresenter?.permittedArrowDirections = .any
        }
        
        self.viewController?.present(alertController!, animated: true, completion: nil)
    }
    
    private func selectPicture(pickerType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(pickerType){
            DispatchQueue.main.async {
                self.pickerController.delegate = self
                self.pickerController.sourceType = pickerType;
                self.pickerController.mediaTypes = [kUTTypeImage as String]
                self.pickerController.allowsEditing = false
                self.pickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                self.pickerController.navigationBar.tintColor = UIColor.white
                self.pickerController.navigationBar.barTintColor = self.viewController?.navigationController?.navigationBar.barTintColor
                self.pickerController.modalPresentationStyle = UIModalPresentationStyle.currentContext
                self.viewController?.present(self.pickerController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate methods

extension PhotoPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString;
        var originalImage, editedImage, imageToUse: UIImage?
        
        if (CFStringCompare(mediaType as CFString, kUTTypeImage, .compareCaseInsensitive) == CFComparisonResult.compareEqualTo) {
            editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if editedImage != nil {
                imageToUse = editedImage
            } else {
                imageToUse = originalImage
            }
            
            if let validDelegate = imagePickerDelegate, let validImage = imageToUse {
                validDelegate.photoPicker(picker: self, didSelectImage: validImage)
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}


