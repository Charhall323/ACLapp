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
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in //for this user
                if let error = error as NSError? { //if there is an error in the password (does not follow designated parameters)
                switch AuthErrorCode(rawValue: error.code) { //then there is an error
                default:
                    self.showAlert(message: "Cannot create user") //the password cannot be created, alert shown (calls function below showing error message)
                }
              } else {
                  self.sendVerificationMail() //if the password works have to check if email passes
//                print("User signed up successfully")
//                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                  let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
//                  self.present(vc, animated: true)
//                  var isEmailVerified: Bool { get } was trying to make it not log in until verified
              }
            }
        }
        else { //print error message if password does not work
            print("Password not long enough") //showing user password is not long enough
        }
    }
    
    func isValidPassword(_ password: String) -> Bool { //creating parameters for user password created
        let minPasswordLength = 6 //user password length at minimum of 6
        return password.count >= minPasswordLength //password has to be equal or more than six characters 
      }
    
    func sendVerificationMail() { //checking if can send a verification email
        let authUser = Auth.auth().currentUser //identifying the the current user
        if authUser != nil && !authUser!.isEmailVerified { //if the user can send an email
            authUser!.sendEmailVerification(completion: { (error) in //try to send the email to user
                //notify the user that the mail has send or could nbot have because of an error
                if error == nil { //if the email can be sent so there is no error then the email is valid
                    print("User signed up successfully") //the user is successfully signed in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil) //show the initial view controller
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabController") //showing specific page
                    self.present(vc, animated: true) //show that page
                }
                else
                {
                    self.showAlert(message: "Invalid Email") //if the verification email cannot be sent then the email is not real, show message saying invalid email), calls show Alert method to show email does not work
                }
            })
        }
        else {
            //either the user is not available, or the user is already verified
                            
        }
    }
    
    func showAlert(message: String) { //used to just be able to show an alert to the user (ex: invalid username/password, incorrect email, cannot log in etc)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert) //create error message
        self.present(alert, animated: true, completion: nil) //actually shows message
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in alert.dismiss(animated: true, completion: nil)}) //alert shown (alert removed after error message has been seen (3 seconds interval)
    }
    

}


