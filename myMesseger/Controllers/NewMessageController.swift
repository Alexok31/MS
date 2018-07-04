//
//  SearchUsersController.swift
//  myMesseger
//
//  Created by Александр Харченко on 22.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class NewMessageController: UITableViewController {
    
    var usersArrey = [UserStructure?]()
    
    @IBOutlet weak var showChat: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        
        
    }
    
    func fetchUser() {
        FirebaseService().fetchAllUsers { (users) in
            self.usersArrey.append(users)
            self.tableView.reloadData()
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArrey.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToChat", sender: self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! NewMessageCell
        
        cell.newMessageSetupCell(indexPath, usersArrey: usersArrey as! [UserStructure])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC2: ChatViewController = segue.destination as! ChatViewController
        let indexPath = tableView.indexPathForSelectedRow
        if indexPath != nil {
            destinationVC2.users = usersArrey[(indexPath?.row)!]
        }
    }
}
