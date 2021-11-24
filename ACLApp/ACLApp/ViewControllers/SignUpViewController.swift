//
//  SignUpViewControllers.swift
//  ACLApp
//
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        let email = usernameTextfield.text!
        let password = passwordTextfield.text!
        
        if isValidPassword(password) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                default:
                    print("Error: \(error.localizedDescription)")
                }
              } else {
                print("User signed up successfully")
                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                  self.present(vc, animated: true)
              }
            }
        }
        else {
            print("Password not long enough")
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let minPasswordLength = 6
        return password.count >= minPasswordLength
      }

}


