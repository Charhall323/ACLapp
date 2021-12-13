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
import FirebaseInstallations
import FirebaseAnalytics
import FirebaseDatabase



class ProgressViewController: UIViewController {
    
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
          
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        UploadToCloud() //for Name and Date
    }
    
    
    func UploadToCloud() {
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy";
        let strDate = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "MM0dd-yyyy HH:mm:SS AM"
        
        let currentDateTime = dateFormatter.string(from: Date())
        
        ref.child(fullName.text!).setValue(
        [
            "name": fullName.text!,
            "Date": strDate,
            "Uploaded DateTime": currentDateTime
        ]
        )
    }
    
    
    
}



//ref.child('users').orderByChild('name').equalTo('John Doe').on("value", function(snapshot) {
//    console.log(snapshot.val());
//    snapshot.forEach(function(data) {
//        console.log(data.key);
//    });
//});


    //    private var db = Firestore.firestore()
//        var ref = firebase.database().ref();
//
//        ref.on("value", function(snapshot) {
//           console.log(snapshot.val());
//        }, function (error) {
//           console.log("Error: " + error.code);
//        });
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

