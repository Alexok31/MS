//
//  sendImegToChat.swift
//  myMesseger
//
//  Created by Александр Харченко on 27.06.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import Foundation
import UIKit

extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectImag() {
        let imagPickerController = UIImagePickerController()
        imagPickerController.delegate = self
        imagPickerController.allowsEditing = true
        present(imagPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            FirebaseHelper().uploadToFirebaseStorageUsingImag(selectedImage, toId: (users?.id)!)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadToFirebaseStorageUsingImag(_ image: UIImage) {
        print("svsrvs")
    }

}
