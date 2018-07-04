//
//  FirebaseHelper.swift
//  myMesseger
//
//  Created by User on 06.06.18.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class FirebaseService: MessageReceivable {
    
    var didReceiveNewMessage: ((MessageStructure) -> ())?
    var getData = GetData()
    
    func chatPartnerId(for message: MessageStructure) -> String? {
        return message.fromId == Auth.auth().currentUser?.uid ? message.toId : message.fromId
        
    }
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    
    func receivingUsersFromFireDat(message: MessageStructure, completion: @escaping ((UserStructure) -> ())) {
        
        let partherId = chatPartnerId(for: message)
        guard let chatPartnerId = partherId else { return }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            var user = self.getData.getUsers(from: dictionary)
            user?.id = partherId
            completion(user!)
        }
    }
    
    func fetchAllUsers(completion: @escaping ((UserStructure) -> ())) {
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
            let dictionary = snapshot.value as? [String : Any]
            var users = self.getData.getUsers(from: dictionary!)
            users?.id = snapshot.key
            completion(users!)
            
            
        }
    }
    
    func getUserInfo(completion: @escaping ((UserStructure) -> ())) {
        let curentId = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(curentId!).observe(.value) { (snapshot) in
            
            let dictionary = snapshot.value as? [String : Any]
            let users = GetData().getUsers(from: dictionary!)
            completion(users!)
           
        }
    }
        
}

