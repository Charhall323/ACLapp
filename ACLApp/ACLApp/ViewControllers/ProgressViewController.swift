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
import EventsCalendar



class ProgressViewController: UIViewController, CalendarViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var allEvents: [EventsMonth] = []
    var currentMonth: EventsMonth = EventsMonth()
    var eventsForTheDay: [Event] = []
    
    //comes from events calendar cocoa pods
    lazy var monthCalendarView = { () -> MonthCalendarView in
        var dateComp = DateComponents()
        dateComp.year = 1
        var dateComp2 = DateComponents()
        dateComp2.year = -1
        let view = MonthCalendarView(
            startDate: Calendar.current.date(byAdding: dateComp2, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: dateComp, to: Date()) ?? Date()
            )
        view.allowsDateSelection = true // default value: true
        view.selectedDate = Date()
        
        view.isPagingEnabled = true // default value: true
        view.scrollDirection = .horizontal // default value: .horizontal
        view.viewConfiguration = CalendarConfig() // default valut: .default
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func downloadEvents() {
        activityIndicator.startAnimating()
        let ref = Database.database().reference()
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MM"
        let yearDateFormatter = DateFormatter()
        yearDateFormatter.dateFormat = "YYYY"
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd"
        ref.child("users/\(Auth.auth().currentUser?.uid ?? "")/events").observe(.value, with:{ (snapshot: DataSnapshot) in
            let dateFormatter = DateFormatter()
            let todayM = monthDateFormatter.string(from: Date())
            let todayY = yearDateFormatter.string(from: Date())
            dateFormatter.dateFormat = "MM/dd/YYYY HH:mm:ss"
            for ev in snapshot.children {
                if let child = ev as? DataSnapshot {
                    if let each = child.value! as? [String: AnyObject] {
                        if let dateStr = each["dateWatched"] as? String, let timeStr = each["timeWatched"] as? String, let videoStr = each["videoWatched"] as? String {
                            let e = Event()
                            e.date = dateFormatter.date(from: "\(dateStr) \(timeStr)") ?? Date()
                            let m = monthDateFormatter.string(from: e.date)
                            let y = yearDateFormatter.string(from: e.date)
                            let d = dayDateFormatter.string(from: e.date)
                            e.time = timeStr
                            e.description = videoStr
                            if self.allEvents.count == 0
                            {
                                let newEventMonth = EventsMonth()
                                newEventMonth.month = m
                                newEventMonth.year = y
                                let newEventDate = EventDate()
                                newEventDate.date = dateStr
                                newEventDate.day = Int(d) ?? 1
                                newEventDate.events.append(e)
                                newEventMonth.days.append(newEventDate)
                                self.allEvents.append(newEventMonth)
                            }
                            else {
                                for eventMonth in self.allEvents {
                                    if eventMonth.month == m && eventMonth.year == y {
                                        let index = eventMonth.days.firstIndex(where: ({$0.date == dateStr})) ?? -1
                                        if index != -1 {
                                            eventMonth.days[index].events.append(e)
                                        }
                                        else {
                                            let newEventDate = EventDate()
                                            newEventDate.date = dateStr
                                            newEventDate.day = Int(d) ?? 1
                                            newEventDate.events.append(e)
                                            eventMonth.days.append(newEventDate)
                                        }
                                    }
                                    else {
                                        let newEventMonth = EventsMonth()
                                        newEventMonth.month = m
                                        newEventMonth.year = y
                                        let newEventDate = EventDate()
                                        newEventDate.date = dateStr
                                        newEventDate.day = Int(d) ?? 1
                                        newEventDate.events.append(e)
                                        newEventMonth.days.append(newEventDate)
                                        self.allEvents.append(newEventMonth)
                                        break
                                    }
                                    if eventMonth.month == todayM && eventMonth.year == todayY {
                                        self.currentMonth = eventMonth
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            let dayDateFormatter = DateFormatter()
            dayDateFormatter.dateFormat = "dd"
            let todayD = dayDateFormatter.string(from: Date())
            for day in self.currentMonth.days {
                if day.day == Int(todayD) ?? 0 {
                    self.eventsForTheDay = day.events
                }
            }
            self.monthCalendarView.delegate = self
            self.monthCalendarView.frame = self.calendarContainer.bounds
            self.calendarContainer.addSubview(self.monthCalendarView)
            self.activityIndicator.stopAnimating()
            self.tableView.reloadDate()
        })
    }
    
    func calendarView(_ calendarView: CalendarProtocol, didChangeSelectionDateTo date: Date, at indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MM"
        let yearDateFormatter = DateFormatter()
        yearDateFormatter.dateFormat = "YYYY"
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd"
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let str = dateFormatter.string(from: date)
        let strM = monthDateFormatter.string(from: date)
        let strY = yearDateFormatter.string(from:date)
        let strD = dayDateFormatter.string(from:date)
        var dayFound = false
        if strM != currentMonth.month || strY != currentMonth.year {
            for month in allEvents {
                if strM == month.month && strY == month.year {
                    self.currentMonth = month
                    for d in month.days {
                            if d.day == Int(strD) ?? 1 {
                                eventsForTheDay = d.events
                                dayFound = true
                                break
                            }
                        }
                    break
                    }
                }
            }
        else {
            for d in currentMonth.days {
                if d.day == Int(strD) ?? 1 {
                    eventsForTheDay = d.events
                    dayFound = true
                    break
                }
            }
        }
        if !dayFound {
            eventsForTheDay = []
        }
        tableView.reloadData()
    }
    
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date) -> Set<Int>?
    {
        var days: [Int] = []
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MM"
        let monthRefStr = monthDateFormatter.string(from: referenceDate)
        let yearDateFormatter = DateFormatter()
        yearDateFormatter.dateFormat = "YYYY"
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd"
        let yearRefStr = yearDateFormatter.string(from: referenceDate)
        for month in allEvents {
            if month.month == monthRefStr && month.year == yearRefStr {
                for day in month.days {
                    days.append(day.day)
                }
            }
        }
        return Set(days.map{$0})
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let event = self.eventsForTheDay[indexPath.row]
        cell.textLabel?.text = "\(event.time) - \(event.description)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsForTheDay.count
    }
    
    
}






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


//
//@IBAction func submitButton(_ sender: Any) {
//    UploadToCloud() //for Name and Date
//}
//
//
//func UploadToCloud() {
//    let ref = Database.database().reference()
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM-dd-yyyy";
//    let strDate = dateFormatter.string(from: datePicker.date)
//    dateFormatter.dateFormat = "MM0dd-yyyy HH:mm:SS AM"
//
//    let currentDateTime = dateFormatter.string(from: Date())
//
//    ref.child("History Log").child(fullName.text!).setValue(
//    [
//        "name": fullName.text!,
//        "Date": strDate,
//        "Uploaded DateTime": currentDateTime
//    ]
//    )



