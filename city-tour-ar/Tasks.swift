//
//  Tasks.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import Foundation
import MapKit

let defaultTour = Tour(id: "l1", name: "Test tour")
let testKrakowTour = Tour(id: "l2", name: "Kraków City Center")

struct Coords: Hashable, Codable {
    var lat: Double
    var long: Double
    
    func asCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func asMapItem() -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: asCoordinate()))
    }
}

struct TourTask: Hashable, Codable {
    var tourId: String = defaultTour.id
    var name: String
    var description: String
    var location: Coords = Coords(lat: 50.063489, long: 19.930816)
}

struct Tour: Hashable, Codable {
    var id: String
    var name: String
    var city = "Krakow"
}

let defaultTasks = [
    TourTask(
        name: "medal",
        description: "Look for the blue book with stars on the cover.",
        location: Coords(lat: 50.064861, long: 19.924016)
    ),
    TourTask(name: "other", description: "Try to look for the other book.",  location: Coords(lat: 50.064, long: 19.92)),
    TourTask(name: "other2", description: "And another one"),
    
    TourTask(
        tourId: testKrakowTour.id,
        name: "malczewski",
        description: "Look for a memorial commemorating Jacek Malczewski. What year did he start living where you're standing today?",
        location: Coords(lat: 50.063489, long: 19.930816)
    ),
    
    TourTask(
        tourId: testKrakowTour.id,
        name: "bagatela",
        description: "Look for a memorial plate about the Bagatela Theater, which you will stand next to. Hint: you might need to look down. Who came up with the name Bagatela?",
        location: Coords(lat: 50.06355, long: 19.93264)
    ),
    
    TourTask(
        tourId: testKrakowTour.id,
        name: "mickiewicz",
        description: "This monument of Adam Mickiewicz is a common meeting spot for locals. What is the year written on the back of it?",
        location: Coords(lat: 50.061400, long: 19.938143)
    ),
]

let defaultTours = [defaultTour, testKrakowTour]
