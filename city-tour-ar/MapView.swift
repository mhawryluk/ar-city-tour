//
//  MapView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        print("1: requesting location")
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("2: ", status)
        
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("3: ", locations)
        
        if locations.first != nil {
            location = locations.first?.coordinate
        }
    }
}

struct MapView : View {
    
    let tasks: [TourTask]
    let currentTaskIndex: Int
    
    @State private var showingAllTasks: Bool = false
    @StateObject var locationManager = LocationManager()
    @State var route: MKRoute?
    @State var showingRoute = false
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 50.061389, longitude: 19.938333),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Map")
                    .font(.title)
                    .frame(alignment: .leading)
                    .bold()
                
                HStack {
                    Spacer()
                    
                    Button {
                        showingRoute.toggle()
                        
                        if showingRoute {
                            getDirections()
                        }
                    } label: {
                        if showingRoute && route == nil {
                            ProgressView()
                        } else {
                            Label(showingRoute ? "Hide route" : "Show route", systemImage: "arrow.triangle.turn.up.right.diamond")
                                .padding(.vertical, 5)
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.accent.opacity(0.2))
                    .foregroundStyle(.accent)
                    
                    Menu {
                        Button {
                            showingAllTasks.toggle()
                        } label: {
                            VStack {
                                Label(showingAllTasks ? "Show only completed and current tasks" : "Show all tasks", systemImage: "eyeglasses")
                            }
                        }
                        Button {
                            position = MapCameraPosition.region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(
                                        latitude: tasks[currentTaskIndex].location.lat,
                                        longitude: tasks[currentTaskIndex].location.long),
                                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                                )
                            )
                        } label: {
                            Label("Center on current task", systemImage: "mappin.circle")
                        }
                        
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                            .labelStyle(.iconOnly)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accent.opacity(0.2))
                    .foregroundStyle(.accent)
                }
            }.padding(.top, 30)
            
            Map(position: $position) {
                UserAnnotation()
                
                ForEach(Array(tasks.enumerated()), id: \.offset) { index, task in
                    
                    if showingAllTasks || index <= currentTaskIndex {
            
                        if index == currentTaskIndex {
                            MapCircle(
                                
                                center: CLLocationCoordinate2D(
                                    latitude: task.location.lat,
                                    longitude: task.location.long),
                                
                                radius: 20
                            ).foregroundStyle(
                                .blue.opacity(0.2)
                            )
                        }
                        
                        Annotation(
                            "#\(index + 1) (\(task.name))",
                            coordinate: CLLocationCoordinate2D(
                                latitude: task.location.lat,
                                longitude: task.location.long
                            )
                        ) {
                            ZStack {
                                
                                if index == currentTaskIndex {
                                    
                                    Circle()
                                        .fill(
                                            .blue.opacity(0.8)
                                        )
                                    
                                    Image(systemName: "mappin.and.ellipse")
                                        .padding(10)
                                } else if index < currentTaskIndex {
                                    Circle()
                                        .fill(
                                            .accent.opacity(0.8)
                                        )
                                    
                                    Image(systemName: "checkmark")
                                        .padding(10)
                                } else {
                                    Circle()
                                        .fill(
                                            .secondary.opacity(0.8)
                                        )
                                    
                                    Image(systemName: "mappin.and.ellipse")
                                        .padding(10)
                                }
                            }
                        }
                    }
                }
                
                if showingRoute {
                    if let route {
                        MapPolyline(route)
                            .stroke(.blue, lineWidth: 5)
                    }
                }
                
            }.mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .mapStyle(.standard(elevation: .realistic))
        }
        .padding(.horizontal)
        .onAppear {
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: tasks[currentTaskIndex].location.lat,
                        longitude: tasks[currentTaskIndex].location.long),
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
            
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { newLocation in
            getDirections()
        }
        
        TaskView(
            task: tasks[currentTaskIndex],
            index: currentTaskIndex + 1,
            isCompleted: false,
            isHighlighted: true
        ){
            
        }.padding()
    }
    
    
    func getDirections() {

        guard let location = locationManager.location else {
            return
        }
        
        print("current location: ", location)
        
        self.route = nil
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
        request.destination = self.tasks[self.currentTaskIndex].location.asMapItem()
        request.transportType = .walking
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}


#Preview {
    MapView(tasks: defaultTasks, currentTaskIndex: 0)
}

extension CLLocationCoordinate2D {
    static let mariacki = CLLocationCoordinate2D(latitude: 50.061667, longitude: 19.939444)
}
