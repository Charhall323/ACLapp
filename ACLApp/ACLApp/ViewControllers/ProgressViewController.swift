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
//installed all cocoa pods above by typing them in and then typing pod install - enables additional functionalities



class ProgressViewController: UIViewController, CalendarViewDelegate, UITableViewDataSource, UITableViewDelegate{
    //delegate = allows an object to communicate back to its owner in an uncoupled way - can be used to control or modify the behavior of another object
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var allEvents: [EventsMonth] = []
    var currentMonth: EventsMonth = EventsMonth()
    var eventsForTheDay: [Event] = []
    
    //comes from events calendar cocoa pods
    lazy var monthCalendarView = { () -> MonthCalendarView in
        var dateComp = DateComponents()
        dateComp.year = 1 // one year in the future
        var dateComp2 = DateComponents()
        dateComp2.year = -1 // today
        let view = MonthCalendarView(
            startDate: Calendar.current.date(byAdding: dateComp2, to: Date()) ?? Date(), //starts at today -1 year (so calendar goes back to december 2020 when it is december 2021)
                //do not see this as the page because of scroll view (created further below)
            endDate: Calendar.current.date(byAdding: dateComp, to: Date()) ?? Date() //current date is this month that is what it goes to (do not need future months because could not watch a video at a future date)
            )
        view.allowsDateSelection = true
        view.selectedDate = Date()
        
        view.isPagingEnabled = true
        view.scrollDirection = .horizontal
        view.viewConfiguration = CalendarConfig()
        return view
    }()
    
    //tells it to download events everytime the screen shows up
    override func viewDidAppear(_ animated: Bool) {
        allEvents = []
        currentMonth = EventsMonth()
        eventsForTheDay = []
        downloadEvents()
        //telling it to scroll to the current date
        self.monthCalendarView.isHidden = true
        self.monthCalendarView.scroll(to: Date(), animated: false)
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.monthCalendarView.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
    }
    
    func downloadEvents() {
        activityIndicator.startAnimating() //tells the indicator to start showing (tells people that the calendar is loading basically, something is happening, gives time to load the events from firebase)
        let ref = Database.database().reference() //setting up the connection to firebase
        //date comes in as a parameter so can convert the date to a string using the DateFormatter
        let monthDateFormatter = DateFormatter() //needed to see the month as a seperate variable
        monthDateFormatter.dateFormat = "MM" //see the month as a string
        let yearDateFormatter = DateFormatter() //needed to see the year as a seperate variable
        yearDateFormatter.dateFormat = "YYYY" //see the year as a string
        let dayDateFormatter = DateFormatter() //needed to see the date as a seperate variable
        dayDateFormatter.dateFormat = "dd" //see the date as a string
        ref.child("users/\(Auth.auth().currentUser?.uid ?? "")/events").observe(.value, with:{ (snapshot: DataSnapshot) in //starts searching database by child
            let dateFormatter = DateFormatter() //date comes in as a parameter so can convert the date to a string using the DateFormatter
            let todayM = monthDateFormatter.string(from: Date()) //gets todays month, date, and year
            let todayY = yearDateFormatter.string(from: Date()) //gets todays month, date, and year
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss" //turing into a string, want the month date, year, at the hour, minutes, and seconds
            for ev in snapshot.children { //snapshot = database is always running so have to pull the snapshot of it (basically take a picture)
                if let child = ev as? DataSnapshot { //iterating through the events on the database, everything watched and each row/object on the database and getting all of the information from that including the time, the date, and the video you atched
                    if let each = child.value! as? [String: AnyObject] { //looking at specific child branch, checking that it is an object
                        //as? = mean it could be null statement since it does not know what the data looks like so you have to check that it is giving the data that you are expecting
                        if let dateStr = each["dateWatched"] as? String, let timeStr = each["timeWatched"] as? String, let videoStr = each["videoWatched"] as? String { //checking that this object you are looking at has the three descripters (datewatched, timewatched, and videowatched) that you are expecting
                            let e = Event() //creating an event object
                            e.date = dateFormatter.date(from: "\(dateStr) \(timeStr)") ?? Date() //formatting the date and time from the event
                            let m = monthDateFormatter.string(from: e.date) //getting month
                            let y = yearDateFormatter.string(from: e.date) //getting year
                            let d = dayDateFormatter.string(from: e.date) //getting date
                            e.time = timeStr //read the time as a string (formatted above)
                            e.description = videoStr //read the time as a string (formatted above)
                            //if there is no months add the month, day, event
                            if self.allEvents.count == 0 //BEGIN HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
                                //look for month add month, add day to month
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
            self.monthCalendarView.frame = self.containerView.bounds
            self.containerView.addSubview(self.monthCalendarView)
            self.tableView.reloadData()
//            self.monthCalendarView.scroll(to:Date()) //tells calendar view to go to todays date
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
        self.monthCalendarView.scroll(to: Date(), animated: true) //CHANGED THIS
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
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
        catch {
            print("Sign out failed")
        }
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



