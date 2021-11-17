//
//  ViewController.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 11/11/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var UserTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var SigninButton: UIButton!
    
    //just making rounder
    //xxxxx
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = UserTextField.text!
        let password = passwordTextfield.text!
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            default:
                print("Error: \(error.localizedDescription)")
                self.UserTextField.text = ""
                self.passwordTextfield.text = ""
            }
          } else {
                print("User signed in successfully")
                let userInfo = Auth.auth().currentUser
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                self.present(vc, animated: true)
          }
        }
    }
    

}

