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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! ChatTableViewCell
        let message = messagesArray[indexPath.row]
        let partherId = firebaseService.chatPartnerId(for: message)

        if partherId != nil {
            firebaseService.receivingUsersFromFireDat(message: message) { (user) in
                if user.username != nil {
                    cell.usernameLabel.text = user.username
                }
                else {
                    cell.usernameLabel.text = user.email
                    
                }
                
                if user.profileImage != nil {
                    
                    cell.avatarImegView.layer.masksToBounds = true
                    cell.avatarImegView.layer.cornerRadius = 30
                    cell.contentMode = .scaleAspectFill
                    cell.avatarImegView.downloadImeg(from: (user.profileImage)!)
                }
                
            }
            
            cell.messageLabel.text = self.messagesArray[indexPath.row].textMessage
        }
        
        if let second = messagesArray[indexPath.row].timeSendMessage{
            let timestampData = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: second)))
            let dateFormat = DateFormatter()
            dateFormat.timeStyle = .short
            dateFormat.dateStyle = .none
            dateFormat.locale = Locale(identifier: "ru_UA")
            cell.timeLabel.text = dateFormat.string(from: timestampData as Date)
            cell.timeLabel.clipsToBounds = true
            cell.timeLabel.layer.cornerRadius = 8
        }
        return cell
    }
}
