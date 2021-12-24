//
//  EventObjects.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 12/23/21.
//

import Foundation

class Event {
    var date: Date = Date()
    var time: String = ""
    var description: String = ""
}

class EventDate {
    var day: Int = 1
    var date: String = ""
    var events: [Event] = []
}

class EventsMonth {
    var month: String = ""
    var year: String = ""
    var days: [EventDate] = []
}
