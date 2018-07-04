//
//  NewMessageCell.swift
//  myMesseger
//
//  Created by Александр Харченко on 25.06.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    func newMessageSetupCell(_ indexPath: IndexPath, usersArrey: [UserStructure] )  {
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        if usersArrey[indexPath.row].username != nil {
            profileName?.text = usersArrey[indexPath.row].username
        } else {
            profileName?.text = usersArrey[indexPath.row].email
        }
        let profileImege = usersArrey[indexPath.row].profileImage
        if usersArrey[indexPath.row].profileImage != nil {
            profileImage.downloadImeg(from: profileImege!)
        } else {
            profileImage.image = #imageLiteral(resourceName: "defaultProfileImeg")
        }
    }
}
