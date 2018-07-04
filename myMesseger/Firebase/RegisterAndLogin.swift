//
//  AddUsreToDatabase.swift
//  myMesseger
//
//  Created by Александр Харченко on 17.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

class RegisterAndLogin  {
    
    var isUserAuth: Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    func handleLogin(email: String, password: String, completion: @escaping ((Error?) -> ())) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            completion(error)
        }
    }
    
    func handleRegister(email: String, password: String, completion: @escaping ((Error?) -> ()), completion2: @escaping ((AuthDataResult?) -> ()))  {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            completion(error)
            completion2(authResult)
        }
    }
    
    func addNewUserInFireBase(email: String, password: String, user: AuthDataResult?) {
        
        guard let uid = user?.user.uid else {
                return
            }
        let ref = Database.database().reference(fromURL: "https://imdead-3a68f.firebaseio.com/")
        let userReference = ref.child("users").child(uid)
        let values = ["email": email]
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
        })
            
    }
   
    
    
  
    
    
}
