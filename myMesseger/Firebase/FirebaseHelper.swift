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
    
    var authorization = Auth.auth()
    let curentUser = Auth.auth().currentUser
    let ref = Database.database().reference()
    let storeg = Storage.storage()
}

