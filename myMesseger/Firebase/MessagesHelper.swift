//
//  SendMasseges.swift
//  myMesseger
//
//  Created by Александр Харченко on 13.06.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth
import Firebase

class MessagesHelper {
    
    func handleSendMasseges(messege: String?, toId: String, imageMessage: String?) {
        let ref =  Database.database().reference().child("messeges")
        let childFef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser?.uid
        let timeSendMessege = NSDate().timeIntervalSince1970
        let value = ["textMessage": messege ?? String.self, "imageMessage": imageMessage ?? String.self, "toId": toId, "fromId" : fromId!, "timeSendMessage": timeSendMessege] as [String : Any]
        childFef.updateChildValues(value) { (error, ref) in
            if error != nil  {
                print(error!)
                return
            }
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId!)
            let messageId = childFef.key
            userMessageRef.updateChildValues([messageId : "From"])
            let recipientMessageRef = Database.database().reference().child("user-messages").child(toId)
            recipientMessageRef.updateChildValues([messageId : "To"])
        }
       
    }
    
    
    
    func receivingMessagesFromFireData(completion: @escaping ((MessageStructure) -> ()))  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        
        ref.observe(.childAdded) { (snapshot1) in
            
            let messageId = snapshot1.key
            let messageFef = Database.database().reference().child("messeges").child(messageId)
            
            messageFef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any],
                    let message = GetData().getMessage(from: dictionary) {
                    
                    completion(message)
                }
            })
        }
    }
    
    func observeMassages(completion: @escaping ((MessageStructure) -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userMessagRef = Database.database().reference().child("user-messages").child(uid)
        userMessagRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messeges").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                let message = GetData().getMessage(from: dictionary)
                completion(message!)
            })
        }, withCancel: nil)
    }
}
