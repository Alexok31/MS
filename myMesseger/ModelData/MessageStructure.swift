//
//  message.swift
//  myMesseger
//
//  Created by Александр Харченко on 24.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import Foundation

struct MessageStructure: Codable {
    
    var fromId : String?
    var toId : String?
    var textMessage : String?
    var timeSendMessage: Double?
}
