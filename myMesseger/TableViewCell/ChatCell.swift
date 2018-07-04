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
    
    @IBOutlet weak var userIamge: UIImageView!
    
    
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var bubbleWidthAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var bubbleRightAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
//        bubbleView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        
        }
    
    
}





