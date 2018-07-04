//
//  LoginMenu.swift
//  myMesseger
//
//  Created by Александр Харченко on 15.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var authorizationView: UIView!
    @IBOutlet weak var authorizationButton: UIButton!
    
    @IBOutlet weak var autoselectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var errorMailLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorpPasswordLabel: UITextField!
    
    var registerAndLogin = RegisterAndLogin()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        authorizationView.layer.cornerRadius = 10
        authorizationButton.layer.cornerRadius = 10
        authorizationButton.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        autoselectionSegmentedControl.addTarget(self, action: #selector(handleLoginRegistrChange), for: .valueChanged)
    }
    
    @objc func handleLoginOrRegister() {
        
        if autoselectionSegmentedControl.selectedSegmentIndex == 0 {
            
            handleLogin()
        } else {
            
            handleRegister()
        }
    }
    
    
    func handleLogin() {
        registerAndLogin.handleLogin(email: mailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                self.errorMailLabel.text = (error?.localizedDescription)
            } else {
                MessagesTableViewController().updateData()
                self.pushMessagesView()
            }
        }
    }
    
    func handleRegister() {
        registerAndLogin.handleRegister(email: mailTextField.text!, password: passwordTextField.text!, completion: { (error) in
            if error != nil {
                
                self.errorMailLabel.text = error?.localizedDescription
                return
            }
        }) { (authResult) in
            RegisterAndLogin().addNewUserInFireBase(email: self.mailTextField.text!, password: self.passwordTextField.text!, user: authResult)
            self.pushMessagesView()
        }
    }
    
    @objc func handleLoginRegistrChange() {
        
        errorMailLabel.text = ""
        
        let titel = autoselectionSegmentedControl.titleForSegment(at: autoselectionSegmentedControl.selectedSegmentIndex)
        authorizationButton.setTitle(titel, for: .normal)
        
        
    }
    
    func pushMessagesView() {
        let message = self.storyboard?.instantiateViewController(withIdentifier: "messegesId") as? MessagesTableViewController
        self.navigationController?.pushViewController(message!, animated: true)
    }

    
}
