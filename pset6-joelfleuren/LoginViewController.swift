//
//  LoginViewController.swift
//  pset6-joelfleuren
//
//  Created by joel fleuren on 16-12-16.
//  Copyright © 2016 joel fleuren. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "userUID") != nil {
            performSegue(withIdentifier: "LoggedInSegue", sender: nil)
        }
        
        performSegue(withIdentifier: "LoggedInSegue", sender: nil)
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        if (emailTextField.text?.characters.count)! > 0 && (passwordTextField.text?.characters.count)! > 0 {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                // error
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                UserDefaults.standard.set(user!.uid, forKey: "userUID")
                
                self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
                
            })
        }
    }
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        
        if (emailTextField.text?.characters.count)! > 0 && (passwordTextField.text?.characters.count)! > 0 {
                        
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                // error
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                UserDefaults.standard.set(user!.uid, forKey: "userUID")
                
                self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
            })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
