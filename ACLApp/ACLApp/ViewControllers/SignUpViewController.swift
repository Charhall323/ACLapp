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
                    self.showAlert(message: "Cannot create user")
                }
              } else {
                  self.sendVerificationMail()
//                print("User signed up successfully")
//                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                  let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
//                  self.present(vc, animated: true)
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
    
    func sendVerificationMail() {
        let authUser = Auth.auth().currentUser
        if authUser != nil && !authUser!.isEmailVerified {
            authUser!.sendEmailVerification(completion: { (error) in
                //notify the user that the mail has send or could nbot have because of an error
                if error == nil {
                    print("User signed up successfully")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                    self.present(vc, animated: true)
                }
                else
                {
                    self.showAlert(message: "Invalid Email")
                }
            })
        }
        else {
            //either the user is not available, or the user is already verified
                            
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in alert.dismiss(animated: true, completion: nil)})
    }
    

}


