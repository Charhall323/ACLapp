//
//  ProgressViewController.swift
//  ACLApp
//
//  
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
    
    var allEvents: [EventsMonth] = [] //setting up calendar view (all events)
    var currentMonth: EventsMonth = EventsMonth() //setting up calendar view (current months on)
    var eventsForTheDay: [Event] = [] //setting up calendar view (specifically for the day events)
    
    //comes from events calendar cocoa pods
    //initiates the calendar view, setting the variables for it initially
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
    
    //tells it to download events everytime the screen shows up, pops up every time the screen pops up, says do all these things every time view appears (ex: reseting events in local class so can pull from firebase, setting up calendar view and timer)
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
            self.activityIndicator.stopAnimating() //hides the activity indicator (when view has loaded)
        }
    }
    //called when the screen is created the first time (only called once so doing things that only need to be called once - happens when screen is initialized, when tabs are creates that screen)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self //for each section of the table, telling the table view that this class handles your methods (delegate, datasource, and register handles method)
        tableView.dataSource = self //for each section of the table
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell") //every time the view does appear download the events and show in table view (returns the number of events for the day)
        
    }
    
    //download events called every time screen appears, get all events from firebase, put them in a form that the calendar can use and update the calendar
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
                if let child = ev as? DataSnapshot { //iterating through the events on the database, everything watched and each row/object on the database and getting all of the information from that including the time, the date, and the video you watched
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
                            if self.allEvents.count == 0 //for the first event ever when there are no months
                                    //when come to the first event ever you are not going to want to look through the months because there are no months, have to create a month for that event before start checking through the month
                                    //creating own month so can store events inside of it (to store our personal events so calendar can understand)
                            {
                                let newEventMonth = EventsMonth() //all events is a list of months so checks if this is the first events ever (checks the database), if it is creates a new event month
                                newEventMonth.month = m //creating new event month
                                newEventMonth.year = y //creating new event year
                                let newEventDate = EventDate() //creating new event date - this part creates a new day for events since that day does not exist in the month (adding that days parameters - day of the month, date, and the event to it)
                                //events live inside the day and the day lives inside the month (just how I chose to create it)
                                newEventDate.date = dateStr //read it as a string from above, adding the days parameters date to it
                                newEventDate.day = Int(d) ?? 1 //adding the days parameters date to it
                                newEventDate.events.append(e) //creating the event (appending it), adding the event to the day
                                newEventMonth.days.append(newEventDate) //apending the event to the day, adding the month to the day
                                self.allEvents.append(newEventMonth) //apend the day(/event) to the month //all parameters added to the event
                            }
                            else { //if we are on the second event or anything past that, looking to see if the month is already there
                                    //look back trhough the months and make sure that month does not already exist
                                for eventMonth in self.allEvents { //have to sort through all the months to see if its there
                                    if eventMonth.month == m && eventMonth.year == y { //if the month and year of the event are the same (already been created), it exists already
                                        let index = eventMonth.days.firstIndex(where: ({$0.date == dateStr})) ?? -1 //have to find that month object
                                            // index = looks through the days in the months and says does the day exist (has there already been a day object created)
                                        if index != -1 { //returns a -1 if the day object has not been created
                                            //if it is not equal to -1 day has been created so then below adding the event to that day because that day has been created
                                            eventMonth.days[index].events.append(e) //adding the event to that day
                                        }
                                        else { //if the day has not been created have to create the day and then add the event to the day
                                            let newEventDate = EventDate() //get that month
                                            newEventDate.date = dateStr //find that month object, get that month days
                                            newEventDate.day = Int(d) ?? 1 //find the month day
                                            newEventDate.events.append(e) //add the event to the day
                                            eventMonth.days.append(newEventDate) //add the event to the day
                                        }
                                    }
                                    else { //for when there are other months object but not this month
                                        let newEventMonth = EventsMonth() //creating new event in the month
                                        newEventMonth.month = m //new event in the month
                                        newEventMonth.year = y //new event in the month within the year
                                        let newEventDate = EventDate() //new event
                                        newEventDate.date = dateStr //making date into string so can manipulate it
                                        newEventDate.day = Int(d) ?? 1
                                        newEventDate.events.append(e) //adding the event to the day
                                        newEventMonth.days.append(newEventDate) //adding the month with it
                                        self.allEvents.append(newEventMonth) //now have new month with event in it
                                        break
                                    }
                                    if eventMonth.month == todayM && eventMonth.year == todayY { //when created the calendar puts the circle as today, sets the today object, basically says I have found today (when the calendar is created today is selected)
                                        self.currentMonth = eventMonth //telling the code where the events for today are (tells us what to display first)
                                        }
                                    }
                            }
                        }
                        }
                    }
                }
            //when first start calendar today would be selected on the calendar so have to pull all events from the today and if there are any events today it puts them there and saves in the events for the day (basically so that todays events show immediately in progress view)
            
            //now know the current month (know what today's month is) but since pulled all events for today's month have to go to the actual day and look through the events and put them in the list that displays at the bottom of the calendar
            let dayDateFormatter = DateFormatter() //gets the day as a seperate variable
            dayDateFormatter.dateFormat = "dd" //sets date parameter as a string
            let todayD = dayDateFormatter.string(from: Date()) //looks at todays event
            for day in self.currentMonth.days { //for event in this month in this day
                if day.day == Int(todayD) ?? 0 { //if we are at today
                    self.eventsForTheDay = day.events //show todays events in the view
                }
            }
            //setting up the calendar
            self.monthCalendarView.delegate = self //helps with seeing calendar view properly
            self.monthCalendarView.frame = self.containerView.bounds //establishes calendar view bounds
            self.containerView.addSubview(self.monthCalendarView) //with how shows calendar view
            self.tableView.reloadData() //data for table view progress reloading so it updates (reloads the rows and sections for the table view)
//            self.monthCalendarView.scroll(to:Date()) //tells calendar view to go to todays date
        })
    }
    //called when you press a different day on the calendar,  (ex: if you click yesterday this would be call to show you yesterdays events)
    func calendarView(_ calendarView: CalendarProtocol, didChangeSelectionDateTo date: Date, at indexPath: IndexPath) { //creates the dots for each day of the month (puts it on the days have events on) 
        let dateFormatter = DateFormatter() //formatting for reading dates
        let monthDateFormatter = DateFormatter() //needed to see month as seperate variable
        monthDateFormatter.dateFormat = "MM" //see the month as a string
        let yearDateFormatter = DateFormatter() //needed to see year as seperate variable
        yearDateFormatter.dateFormat = "YYYY" //see the year as a string
        let dayDateFormatter = DateFormatter() //needed to see the day as seperate variable
        dayDateFormatter.dateFormat = "dd" //see day as string
        dateFormatter.dateFormat = "MM/dd/YYYY" //want the month, day, and year
        let str = dateFormatter.string(from: date) //pulling the date from that date (turning it to a string)
        let strM = monthDateFormatter.string(from: date) //pulling the month from the day
        let strY = yearDateFormatter.string(from:date) //pulling the year as a string from that date
        let strD = dayDateFormatter.string(from:date) //pulling the day from that date
        var dayFound = false //if the day on it is not found yet
        if strM != currentMonth.month || strY != currentMonth.year { //looking for what saelected (date of what you clicked), if it is not the month you are already looking at, have to go through all the months (saving time if day is on the month you are currently on already
            for month in allEvents { //goes through every month in the events (if the month is different)
                if strM == month.month && strY == month.year { //if looking at the correct day and year (makes sure looking at the right place, matches event), finding the month and year you selected
                    self.currentMonth = month
                    for d in month.days { //for every day in the month, that is the month selected
                            if d.day == Int(strD) ?? 1 { //if you are on the correct day, for the day
                                eventsForTheDay = d.events //finds all events for that day (puts them in table view so you can see them), and then pull the events for that day
                                dayFound = true //used so you do not have to continuously go through the months, stop looking because found it
                                break
                            }
                        }
                    break
                    }
                }
            }
        else { //if the current month is the same and do not have to go through the month
            for d in currentMonth.days { //for every day in the month, now going through the days
                if d.day == Int(strD) ?? 1 { //if at correct day, then pull the events
                    eventsForTheDay = d.events //pulls the event in that day (shown in table view so you can see it)
                    dayFound = true //now the day has been found
                    break
                }
            }
        }
        if !dayFound { //if no event then leave day events empty, if the day is not found no events for that day so leave it blank
            eventsForTheDay = [] //keeps day events empty
        }
        tableView.reloadData() //setting up table view so data reloads so it can be displayed
    }
    
    //this one goes through the month and tells it which days to put a dot on, in the whole month telling it which days have events and to put a dot on that date
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date) -> Set<Int>? //returning the day of the calendar view that have events
    {
        var days: [Int] = [] //setting up to look at dates
        let monthDateFormatter = DateFormatter() //needed to see month as seperate variable
        monthDateFormatter.dateFormat = "MM"  //see the month as a string
        let monthRefStr = monthDateFormatter.string(from: referenceDate) //looking at month from date looking at
        let yearDateFormatter = DateFormatter() //needed to see year as seperate variable
        yearDateFormatter.dateFormat = "YYYY" //see the year as a string
        let dayDateFormatter = DateFormatter() //needed to see date as seperate variable
        dayDateFormatter.dateFormat = "dd" //see date as a string
        let yearRefStr = yearDateFormatter.string(from: referenceDate) //looking at year from the date looking at
        for month in allEvents { //for every month in the events
            if month.month == monthRefStr && month.year == yearRefStr { //looks and sees if looking at the correct month and year (finds the correct month and year of month looking at)
                for day in month.days { //for the day in that month found
                    days.append(day.day) //put a dot on that day (because there are events)
                }
            }
        }
        self.monthCalendarView.scroll(to: Date(), animated: true) //used so that the calendar will scroll to the correct year and month that we are currently on (before this was scrolling to one year prior based on the calendar set up)
        return Set(days.map{$0}) //have to return to the calendar what days it has to put dots on, you found them, but then have to tell the calendar what days to put dots on
            //used because the method requires a set of integers to be returned so that they correspond to the days of the month (that require the little dots to mean that they have events on them)
    }
        
    //this table view saying when you have clicked on a day in the calendar sets up the rows on the bottom that tells you the specifics about the events - sets it up (what is inside the row)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //sets up the table view, if there are events put them for the table view (shows event time and video watched)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) //dequeue = returns a reusable table-view cell object after locating it by its identifier
        let event = self.eventsForTheDay[indexPath.row] //putting events into the table view
        cell.textLabel?.text = "\(event.time) - \(event.description)" //how shows in table view row as time watched and video name
        return cell //show the cell
    }
    
    //this table view tells you how many rows there needs to be (physical number of rows) 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsForTheDay.count //creates the proper rows based on how many events have been watched (counts the number of events and then creates rows for them)
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) { //enables the user to sign out
        //checks if you are allowed to sign out and then goes to login screen, if you click this it will go to log in screen
        do {
            try Auth.auth().signOut() //sees if user is able to log out
            performSegue(withIdentifier: "goToLogin", sender: self) //if able to log out sends user to log in screen
        }
        catch {
            print("Sign out failed") //in case user cannot sign out (will not really be used)
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



