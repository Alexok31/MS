//
//  ChatHelper.swift
//  myMesseger
//
//  Created by User on 06.06.18.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import Foundation

protocol MessageReceivable {
    var didReceiveNewMessage: ((MessageStructure) -> ())? { get set }
}

class ChatHelper {
    var messagesArray = [MessageStructure]()
    var messageDictionary = [String: MessageStructure]()
    
    private var messageReceivable: MessageReceivable
    
    var needToUpdateData: (() -> ())?
    init(messageReceivable: MessageReceivable, needToUpdateData: (() -> ())) {
        self.messageReceivable = messageReceivable
    }
    
    func clear() {
        messagesArray.removeAll()
        messageDictionary.removeAll()
    }
    
}
