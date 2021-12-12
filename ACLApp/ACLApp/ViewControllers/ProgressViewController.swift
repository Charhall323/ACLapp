//
//  ProgressViewController.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 12/11/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseCoreDiagnostics


class ProgressViewController: UIViewController {
    private var db = Firestore.firestore()
    @IBOutlet weak var AddCalendarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddCalendarTapped(_ sender: Any) {
        FirebaseApp.configure()
//        var  test = firebase.database().ref("users")
//        var firebaseDatabaseRef: DatabaseReference!
//        ref = Database.database().reference()
//
//        // setting a user value
//        self.ref.child("users").child(user.uid).setValue(["username": username])
//        self.ref.child("users/\(user.uid)/username").setValue(username)
        
//        FirebaseUser currentFirebaseUser = FirebaseAuth.getInstance().getCurrentUser();
//                FirebaseDatabase database = FirebaseDatabase.getInstance();
//            DatabaseReference myRef = database.getReference("users").child( currentFirebaseUser.getUid()).child("friends").setValue("your First Friend");
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
