//
//  EventObjects.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 12/23/21.
//

//purpose: three classes stored in firebase, have to story to properly display in calendar in the case of multiple events (calendar stores by the month but want to display if there are multiple events on the same day)

import Foundation

//creating the event month and event day in the calendar from the event

class Event { //event is the video being viewed
    var date: Date = Date()
    var time: String = ""
    var description: String = ""
}

class EventDate { //event date is the day of the event viewing
    var day: Int = 1
    var date: String = ""
    var events: [Event] = []
}

class EventsMonth { //each month is each month that there is at least one video viewing
    var month: String = ""
    var year: String = ""
    var days: [EventDate] = []
}
