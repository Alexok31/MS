//
//  ChatViewController.swift
//  myMesseger
//
//  Created by Александр Харченко on 24.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldBottom: NSLayoutConstraint!
    @IBOutlet weak var viewLayoutTop: NSLayoutConstraint!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var viewBottm: NSLayoutConstraint!
    @IBOutlet weak var messageSendTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    
    var messageArrey = [MessageStructure]()
    private var height: CGFloat = 80
    var timer: Timer?
   
    
    var users : UserStructure? {
        didSet {
            observeMessages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeybordNotification()
        if users?.username != nil {
            navigationItem.title = users?.username
        } else {
            navigationItem.title = users?.email
        }
        
        chatCollectionView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
//        messegeTextField.layer.cornerRadius = messegeTextField.frame.height / 2
//        messegeTextField.layer.shadowColor = UIColor.red.cgColor
//        messegeTextField.layer.shadowRadius = 2
//        messegeTextField.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func observeMessages()  {
        MessagesHelper().observeMassages { (message) in
            if FirebaseService().chatPartnerId(for: message) == self.users?.id {
                self.messageArrey.append(message)
            }
            DispatchQueue.main.async {
                self.chatCollectionView.reloadData()
//                if self.messageSendTextFieldBottomConstraint.constant != 8 {
//                    self.lowering()
//                }
            }
        }
    }
    
    @IBAction func tapGesters(_ sender: Any) {
       // messegeTextField.resignFirstResponder()
    }
    
    
    deinit {
        removeForKeybordNotification()
    }
    
    ///
    func registerForKeybordNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeForKeybordNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kfFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      //  messageSendTextFieldBottomConstraint.constant = kfFrameSize.height + 8
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (comlated) in
            
            DispatchQueue.main.async {
                self.lowering()
            }
        }
    }
    
    @objc func kbWillHide() {
      //  messageSendTextFieldBottomConstraint.constant = 8
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (comlated) in
            
        }
    }
    
    func lowering() {
        if messageArrey.isEmpty == false {
            let sectionNumber = 0
            self.chatCollectionView?.scrollToItem(at: NSIndexPath.init(row:(self.chatCollectionView.numberOfItems(inSection: sectionNumber))-1, section: sectionNumber) as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        }
        
    }

}

extension ChatViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageArrey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        let message = messageArrey[indexPath.row]
        cell.bubbleView.layer.cornerRadius = 20
        cell.textMessageLabel.text = message.textMessage
        
        setupCell(cell, message: message)
        
        return cell
    }
    
    func setupCell(_ cell: ChatCell, message: MessageStructure) {

            if message.fromId == FirebaseHelper().authorization.currentUser?.uid {
                cell.bubbleView.backgroundColor = UIColor(displayP3Red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
                cell.textMessageLabel.textColor = .white
                cell.bubbleRightAnchor.constant = 5
                cell.bubbleWidthAnchor.constant = (UIScreen.main.bounds.size.width - self.estimateFrameFromText(message.textMessage!).width - 30)
            } else {
                
                cell.bubbleView.backgroundColor = UIColor.white
                cell.textMessageLabel.textColor = .black
                cell.bubbleWidthAnchor.constant = 5
                cell.bubbleRightAnchor.constant = (UIScreen.main.bounds.size.width - self.estimateFrameFromText(message.textMessage!).width - 30)
        }
        
        DispatchQueue.main.async(execute: {
            self.chatCollectionView.reloadData()
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        if let text = messageArrey[indexPath.row].textMessage {
            
            height = estimateFrameFromText(text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameFromText(_ text: String) -> CGRect {
     
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chatCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

