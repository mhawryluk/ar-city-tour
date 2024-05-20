//
//  Tasks.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import Foundation

let defaultTour = Tour(name: "Test tour")
let testKrakowTour = Tour(name: "Kraków City Center")

struct Coords: Hashable {
    var lat: Double
    var long: Double
}

struct Task: Hashable {
    var tourId: UUID = defaultTour.id
    var name: String
    var description: String
    var location: Coords = Coords(lat: 50.063489, long: 19.930816)
}

struct Tour: Hashable {
    var id: UUID = UUID()
    var name: String
    var city = "Krakow"
}

let tasks = [
    Task(
        name: "medal",
        description: "Look for the blue book with stars on the cover.",
        location: Coords(lat: 50.064861, long: 19.924016)
    ),
    Task(name: "other", description: "Try to look for the other book.",  location: Coords(lat: 50.064, long: 19.92)),
    Task(name: "other2", description: "And another one"),
    
    Task(
        tourId: testKrakowTour.id,
        name: "malczewski",
        description: "Look for a memorial commemorating Jacek Malczewski. What year did he start living where you're standing today?",
        location: Coords(lat: 50.063489, long: 19.930816)
    ),
    
    Task(
        tourId: testKrakowTour.id,
        name: "mickiewicz",
        description: "This monument of Adam Mickiewicz is a common meeting spot for locals. What is the year written on the back of it?",
        location: Coords(lat: 50.061400, long: 19.938143)
    ),
]

let tours = [defaultTour, testKrakowTour]
