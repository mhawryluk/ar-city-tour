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
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            location = locations.first?.coordinate
        }
        
    }
}

struct MapView : View {
    
    let tasks: [TourTask]
    let currentTaskIndex: Int
    
    @State private var showingAllTasks: Bool = false
    @State private var route: MKRoute?
    @StateObject var locationManager = LocationManager()
    
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.top, 20)
                
                
                Button {
                    getDirections()
                } label: {
                    Circle()
                        .fill(.accent.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                .font(.system(size: 18.0, weight: .semibold))
                                .foregroundColor(.accent)
                                .padding()
                        }
                }
                .labelStyle(.iconOnly)
                
                
                Menu {
                    Button {
                        showingAllTasks.toggle()
                    } label: {
                        VStack {
                            Label("Show all tasks", systemImage: "eyeglasses")
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
                    Circle()
                        .fill(.accent.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 18.0, weight: .semibold))
                                .foregroundColor(.accent)
                                .padding()
                        }
                }
            }
            .padding()
            
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
                
                if let route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
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
        
        TaskView(
            task: tasks[currentTaskIndex],
            index: currentTaskIndex + 1,
            isCompleted: false,
            isHighlighted: true
        ).padding()
    }
    
    
    func getDirections() {
        locationManager.requestLocation()
        
        guard let location = locationManager.location else {
            return
        }
        
        print("current location: ", location)
        
        self.route = nil
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
        request.destination = self.tasks[self.currentTaskIndex].location.asMapItem()
        
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
