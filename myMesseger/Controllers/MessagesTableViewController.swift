//
//  ViewController.swift
//  myMesseger
//
//  Created by Александр Харченко on 15.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController{
    
    @IBAction func searchUsersButton(_ sender: Any) {
        
    }
    
    var messagesArray = [MessageStructure]()
    var messageDictionary = [String: MessageStructure]()
    var firebaseService = FirebaseService()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserIsLogin()
        updateData()
        receivingMessagesFromFireData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        receivingMessagesFromFireData()
    }
    
    func updateData()  {
        messagesArray.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
    }
    
    func checkUserIsLogin() {
        if RegisterAndLogin().isUserAuth == false {
            let authorizationVc = storyboard!.instantiateViewController(withIdentifier: "LoginView") as! AuthorizationViewController
            navigationController?.pushViewController(authorizationVc, animated: true)
            
        }
    }
    
    func receivingMessagesFromFireData()  {
        
        MessagesHelper().receivingMessagesFromFireData { (message) in
            self.messagesArray.append(message)
            
            
            if let chatPartnerId = self.firebaseService.chatPartnerId(for: message) {
                self.messageDictionary[chatPartnerId] = message
                
                self.messagesArray = Array(self.messageDictionary.values)
                self.messagesArray.sort(by: { (message1, message2) -> Bool in
                    return (message1.timeSendMessage?.hashValue)! > (message2.timeSendMessage?.hashValue)!
                })
            }
            
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc func handleReloadTable() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    
    func showChatControllerToUser(_ user : UserStructure) {
       
        let chatVc = storyboard?.instantiateViewController(withIdentifier: "chatControllerId") as? ChatViewController
        chatVc?.users = user
        navigationController?.pushViewController(chatVc!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messagesArray[indexPath.row]
        firebaseService.receivingUsersFromFireDat(message: message) { (user) in
            self.showChatControllerToUser(user)
        }
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessagesCell
        cell.avatarImagView.layer.cornerRadius =  cell.avatarImagView.frame.height / 2
        let message = messagesArray[indexPath.row]
        cell.messageSetupCell(message, indexPath: indexPath, messagesArray: messagesArray)
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
}
