//
//  PlayerHelper.swift
//  ACLApp
//
//  
//

//purpose: helper class used to get different events from the date (have to do this because in the realitime datebase each child has to have a unique name so the way this helper function is used it will never trigger twice in the same seconds and will always be unique)
import Foundation
import FirebaseDatabase
import FirebaseAuth

class PlayerHelper {
static func uploadLogToFB(grade: String, videoName: String, completionDate: Date) {
    let dateFormatter = DateFormatter() //formatting date
    dateFormatter.dateFormat = "MM/dd/YYYY" //getting the month day and year
    let dateString = dateFormatter.string(from: completionDate)
    dateFormatter.dateFormat = "hh:mm:ss"
    let timeString = dateFormatter.string(from: completionDate)
    dateFormatter.dateFormat = "MM dd YYYY hh:mm:ss" //getting the time
    let uniqueString = dateFormatter.string(from:completionDate) //creating a unique string for the identifier, need unique string because in the realtime database each chiid has to have a unique name, have to do this so that it will always be unique (will never be able to trigger twice in the same second)
    let ref = Database.database().reference() //connecting to firebase
    
    //below is creating the event listing fore firebase - grade, video, date, child
    ref.child("users").child(Auth.auth().currentUser?.uid ?? "unregistered").child("events").child("\(uniqueString)").setValue(["videoWatched": "\(grade): \(videoName)", "dateWatched": dateString, "timeWatched": timeString]) }
}

