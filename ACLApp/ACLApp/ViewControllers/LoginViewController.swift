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
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            default:
                print("Error: \(error.localizedDescription)")
                self.UserTextField.text = "" //delete letters typed
                self.passwordTextfield.text = "" //delete letters typed
            }
            //if the users password does follow the constraints, sign the user in and go to the initation page
          } else {
                print("User signed in successfully")
                let userInfo = Auth.auth().currentUser //logs user info
                let storyboard = UIStoryboard(name: "Main", bundle: nil) //goes to storyboard
                let vc = storyboard.instantiateViewController(withIdentifier: "TabController") //goes to specific view controller
                self.present(vc, animated: true) //presents correct view
          }
        }
    }
    

}

