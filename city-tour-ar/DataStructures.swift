//
//  Tasks.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import Foundation
import MapKit
import ARKit

let defaultTour = Tour(taskNames: ["bottle", "camel", "medal", "other", "other2"], id: "l1", name: "Dev Test Tour. Book Covers")

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

struct PoiInfo: Hashable, Codable {
    var title: String
    var description: String
    var imageIds: [String]
}

struct PoiQuestion: Hashable, Codable {
    var question: String
    var options: [String]
    var correctOption: Int
}

enum TaskCompletionType: String, Codable {
    case ReferenceRecognition
    case LocationAnchor
    case ManualCompletion
    case QuestionCompletion
}

enum SceneType: String, Codable {
    case SceneKit
    case RealityKit
}

struct SceneModelDescriptor: Hashable, Codable {
    var sceneType: SceneType = .SceneKit
    var fileName: String
}

struct ResourceDescriptor: Hashable, Codable {
    var fileName: String
}

struct ReferenceImageDescriptor: Hashable, Codable {
    var fileName: String
    var physicalWidth: Float // in meters
}

struct TourTask: Hashable, Codable {
    var name: String
    var description: String
    var location: Coords = Coords(lat: 50.063489, long: 19.930816)
    var moreInfo: PoiInfo?
    var question: PoiQuestion?
    var sceneModel: SceneModelDescriptor?
    var completionTypes: [TaskCompletionType]? = [.ReferenceRecognition]
    var referenceImages: [ReferenceImageDescriptor]?
    var referenceObjects: [ResourceDescriptor]?
}

struct Tour: Hashable, Codable {
    var taskNames: [String]
    var id: String
    var name: String
    var city = "Krakow"
    var description: String? = nil
}

let defaultTasks = [
    TourTask(
        name: "medal",
        description: "Look for the blue book with stars on the cover.",
        location: Coords(lat: 50.064861, long: 19.924016),
        moreInfo: PoiInfo(title: "This Adventure Ends", description: "A book by Emma Mills", imageIds: ["medal2", "medal2", "medal2"]),
        question: PoiQuestion(question: "How many pages does the book have?", options: ["220", "350", "360", "400"], correctOption: 3),
        referenceImages: [ReferenceImageDescriptor(
            fileName: "medal.jpg",
            physicalWidth: 0.13
        )]
    ),
    TourTask(
        name: "other",
        description: "Try to look for the other book.",
        location: Coords(lat: 50.064, long: 19.92),
        referenceImages: [
            ReferenceImageDescriptor(
                fileName: "other.jpg",
                physicalWidth: 0.135
            )
        ]
    ),
    TourTask(name: "other2", description: "And another one"),
    TourTask(name: "camel", description: "Find a wooden camel statue."),
    TourTask(name: "bottle", description: "Find a red water bottle."),
]

let defaultTours = [defaultTour]
