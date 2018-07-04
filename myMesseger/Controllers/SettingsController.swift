//
//  SettingsController.swift
//  myMesseger
//
//  Created by Александр Харченко on 24.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var avatarImeg: UIImageView!
    
    @IBAction func editAvatarImeg(_ sender: Any) {
        handleSelectProfileImeg()
    }
    
    @IBOutlet weak var nameTextFild: UITextField!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func saveData(_ sender: Any) {
        settings()
        seveNameLabel.text = "Saved!"
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        MessagesTableViewController().updateData()
        logout()
    }
    
    @IBOutlet weak var seveNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()
    }
    
    func settings() {
        let firebaseHelper = FirebaseHelper()
        let curentId = firebaseHelper.curentUser?.uid
        let ref = firebaseHelper.ref
        let storeg = firebaseHelper.storeg
        
        if nameTextFild.text != "" {
            ref.child("users/\(String(describing: curentId!))/username").setValue(nameTextFild.text!)
        }
        let storegRef = storeg.reference().child("Profile_Imeg").child(curentId!)
        if avatarImeg.image != nil {
            let upLoadData = UIImagePNGRepresentation(avatarImeg.image!)
            storegRef.putData(upLoadData!, metadata: nil) { (metadata, error) in
                
            if error != nil {
                print(error!)
                return
            }
            storegRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                ref.child("users/\(String(describing: curentId!))/profileImage").setValue(url?.absoluteString)
            })
            }
        }
    }
    
    func getUserInfo() {
        FirebaseService().getUserInfo { (users) in
            if users.username != nil {
                self.nameTextFild.text = users.username
            }
            if users.profileImage != nil {
                self.avatarImeg.downloadImeg(from: (users.profileImage!))
                self.avatarImeg.clipsToBounds = true
                self.avatarImeg.layer.cornerRadius = 35
            }
            
        }
        emailLabel.text = FirebaseHelper().curentUser?.email
    }
    
    
    func logout() {
        do {
            try FirebaseHelper().authorization.signOut()
        } catch let loginError {
            print(loginError)
        }
        
        let authorizationVc = storyboard!.instantiateViewController(withIdentifier: "LoginView") as! AuthorizationViewController
        navigationController?.pushViewController(authorizationVc, animated: true)
        
    }
}
