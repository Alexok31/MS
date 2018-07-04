//
//  BottomBarChatViewController.swift
//  
//
//  Created by Александр Харченко on 19.06.2018.
//

import UIKit

class BottomBarChatViewController: UIViewController {

    @IBOutlet weak var messegeTextField: UITextField!
    @IBAction func sendMessege(_ sender: Any) {
        if messegeTextField.text != "" {
            print(users?.id)
            MessagesHelper().handleSendMasseges(messege: messegeTextField.text!, toId: (users?.id)!)
            messegeTextField.text = nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseService().fetchAllUsers { (users) in
            print(users.id)
        }

    }
    
    var users : UserStructure? {
        didSet {
            
        }
        
    }

}
