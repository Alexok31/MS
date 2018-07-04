//
//  ChatCell.swift
//  myMesseger
//
//  Created by Александр Харченко on 31.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    
    @IBOutlet weak var textMessageLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var bubbleWidthAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var bubbleRightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var imageMessage: UIImageView!
    
    func setupCell(_ message: MessageStructure) {
        
        if message.fromId == FirebaseHelper().authorization.currentUser?.uid {
            bubbleView.backgroundColor = UIColor(displayP3Red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
            textMessageLabel.textColor = .white
            bubbleRightAnchor.constant = 0
            if let text = message.textMessage {
                bubbleWidthAnchor.constant = (UIScreen.main.bounds.size.width - self.estimateFrameFromText(text).width - 30)
            }
            userImage.isHidden = true
        } else {
            bubbleView.backgroundColor = UIColor.white
            textMessageLabel.textColor = .black
            bubbleWidthAnchor.constant = 33
            bubbleRightAnchor.constant = (UIScreen.main.bounds.size.width - self.estimateFrameFromText(message.textMessage!).width - 57)
            userImage.isHidden = false
            userImage.layer.cornerRadius = userImage.frame.height / 2
            
        }
        if message.imageMessage != nil {
            imageMessage.downloadImeg(from: message.imageMessage!)
            print(message.imageMessage!)
            imageMessage.layer.cornerRadius = 17
            imageMessage.isHidden = false
            bubbleView.backgroundColor = UIColor.clear
        } else {
            imageMessage.isHidden = true
        }
        
    }
    
    func estimateFrameFromText(_ text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
}

