//
//  getData.swift
//  myMesseger
//
//  Created by Александр Харченко on 13.06.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import Foundation

class GetData {
    
    func getMessage(from dictionary: [String : Any]) -> MessageStructure? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return try JSONDecoder().decode(MessageStructure.self, from: jsonData)
        } catch {
            return nil
        }
    }
    
    func getUsers(from dictionary: [String : Any]) -> UserStructure? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return try JSONDecoder().decode(UserStructure.self, from: jsonData)
        } catch {
            return nil
        }
    }
    
}
