//
//  Tasks.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import Foundation

let defaultTour = Tour(name: "Test tour")

struct Task: Hashable {
    var tourId: UUID = defaultTour.id
    var name: String
    var description: String
}

struct Tour: Hashable {
    var id: UUID = UUID()
    var name: String
}

let tasks = [
    Task(name: "medal", description: "Look for the blue book with stars on the cover."),
    Task(name: "other", description: "Try to look for the other book."),
    Task(name: "other2", description: "And another one")
]
