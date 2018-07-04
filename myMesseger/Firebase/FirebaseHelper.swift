//
//  FirebaseHelper.swift
//  myMesseger
//
//  Created by Александр Харченко on 13.06.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper {
    
    var currentEmail = Auth.auth().currentUser?.email
    let authorization = Auth.auth()
    let currentId = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    let storeg = Storage.storage()
    
    func saveAddressPhotoFromStorage(avatarImeg: UIImageView) {
        let storegRef = storeg.reference().child("Profile_Imeg").child(currentId!)
        let upLoadData = UIImagePNGRepresentation(avatarImeg.image!)
        storegRef.putData(upLoadData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!)
                return
            }
            storegRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }
                Database.database().reference().child("users/\(String(describing: self.currentId!))/profileImage").setValue(url?.absoluteString)
            })
        }
    }
    
    func uploadToFirebaseStorageUsingImag(_ image: UIImage, toId: String) {
        let imagName = NSUUID().uuidString
        let storegRef = storeg.reference().child("Message_Imeg").child(imagName)
        let upLoadData = UIImagePNGRepresentation(image)
        storegRef.putData(upLoadData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!)
                return
            }
            storegRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let imageUrl = url?.absoluteString
                MessagesHelper().handleSendMasseges(messege: nil, toId: toId, imageMessage: imageUrl!)
            })
        }
    }
    func saveUserName(name: String) {
        ref.child("users/\(String(describing: currentId!))/username").setValue(name)
    }

}
