//
//  MapView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI
import MapKit

struct MapView : View {
    
    let tasks: [Task]
    let currentTaskIndex: Int
    
    @State private var showingAllTasks: Bool = false
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 50.061389, longitude: 19.938333),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )
    
    var body: some View {
        VStack {
            
            VStack {
                Text("Map")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                
                
                HStack {
                    Button {
                        showingAllTasks.toggle()
                    } label: {
                        VStack {
                            Image(systemName: "eyeglasses").padding(9)
                            Text("Show all tasks")
                        }
                    }
                    .padding()
                    .background(.accent.opacity(0.1))
                    .cornerRadius(10)
                    
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
                        VStack {
                            Image(systemName: "mappin.circle")
                                .padding(5)
                            Text("Center on current task")
                        }
                    }
                    .padding()
                    .background(.accent.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .padding(.top, 30)
            
            
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
                
            }.mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .mapStyle(.standard(elevation: .realistic))
        }.onAppear {
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: tasks[currentTaskIndex].location.lat,
                        longitude: tasks[currentTaskIndex].location.long),
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
        }
    }
}


#Preview {
    MapView(tasks: tasks, currentTaskIndex: 0)
}

extension CLLocationCoordinate2D {
    static let mariacki = CLLocationCoordinate2D(latitude: 50.061667, longitude: 19.939444)
}
