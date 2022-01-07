//
//  ViewController.swift
//  ACLApp
//
//  
//

// purpose: takes in username and password, logs into firebase and if it works takes it to the next screen and if it does not makes it blank

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    //IBOutlet creates connection between storyboard and view controller for objects in the storyboard
    @IBOutlet weak var UserTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var SigninButton: UIButton!
    
    //given
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) { //when the user clicks the log in button
        let email = UserTextField.text! //email is whatever user types in the text box
        //! = force unwrapping of optionals, used if you want to get the optional variable's original value
        let password = passwordTextfield.text! //password is whatever user types in the text box
        //Auth.auth refers to firebase authentication service, gets the user's identification string
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            //if the users password does not follow the constraints, make blank
            //? = optional variable means the variable does not need to be initialized when you defiine it, if you do not initialize it with a default value then its default value is null
            if let error = error as NSError? { //means the error is not null, so got an error back and bad log in
            switch AuthErrorCode(rawValue: error.code) {
            default:
                print("Error: \(error.localizedDescription)")
                self.UserTextField.text = "" //delete letters typed
                self.passwordTextfield.text = "" //delete letters typed
            }
            //if the users password does follow the constraints, sign the user in and go to the initation page
          } else { //no error so now check if actually verified
//                print("User signed in successfully")
                let userInfo = Auth.auth().currentUser //logs user info
              
              //changed this so now it checks to see if the user email is verified, and only once it is verified then it will take the user to the main page
              if (userInfo!.isEmailVerified) { //checking now signed in and email is a legitimate user is the email verified
                  //only once the user is verified, makes sure user is actually verified, has to check if the email is actually verified
                let storyboard = UIStoryboard(name: "Main", bundle: nil) //goes to storyboard
                let vc = storyboard.instantiateViewController(withIdentifier: "TabController") //goes to specific view controller
                self.present(vc, animated: true) //presents correct view
              }
              else {
                  self.showEmailNotVerifiedAlert(authUser: userInfo) //if not verified see alert
              }
          }
        }
    }
    //special alert if the email is not verified to see if need to send another verification email
    func showEmailNotVerifiedAlert(authUser: User?) { //shows a specialized alert for the email not verified
        let alert = UIAlertController(title: "Email not Verified", message: "Please verify your email", preferredStyle: .alert) //creates the alert
        alert.addAction(UIAlertAction(title: "Resend email", style: .default, handler: { action in
            authUser!.sendEmailVerification(completion: { (error) in //creates a button in the alert to resend the verification email
                if error == nil {
                    self.showAlert(title: "Verification Email Sent!", message: "Please check your email for a verification email and once verified, feel free to use the log in option below") }
                else {
                    self.showAlert(title: "Error", message: "Invalid Email")
                }
                })
                }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
                                            
    
    func showAlert(title: String, message: String) { //used to just be able to show an alert to the user (ex: invalid username/password, incorrect email, cannot log in etc)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) //create error message
        self.present(alert, animated: true, completion: nil) //actually shows message
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in alert.dismiss(animated: true, completion: nil)}) //alert shown (alert removed after error message has been seen (3 seconds interval)
    }
    

}

