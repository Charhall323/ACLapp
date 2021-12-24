//
//  PlayerHelper.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 12/23/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class PlayerHelper {
static func uploadLogToFB(grade: String, videoName: String, completionDate: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/YYYY"
    let dateString = dateFormatter.string(from: completionDate)
    dateFormatter.dateFormat = "hh:mm:ss"
    let timeString = dateFormatter.string(from: completionDate)
    dateFormatter.dateFormat = "MM dd YYYY hh:mm:ss"
    let uniqueString = dateFormatter.string(from:completionDate)
    let ref = Database.database().reference()
    
    ref.child("users").child(Auth.auth().currentUser?.uid ?? "unregistered").child("events").child("\(uniqueString)").setValue(["videoWatched": "\(grade): \(videoName)", "dateWatched": dateString, "timeWatched": timeString]) }
}

