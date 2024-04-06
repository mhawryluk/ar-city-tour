//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    var body: some View {
        NavigationStack {
            
            List(tours, id: \.self) { tour in
                NavigationLink {
                    TourView(tourName: tour.name,
                             tasks: tasks.filter { task in
                        task.tourId == tour.id
                    })
                } label: {
                    HStack {
                        
                        Image(systemName: "map.circle.fill")
                        
                        CheckmarkView(textView: AnyView(
                            
                            VStack {
                                Text(tour.name)
                                
                                Text("\(tour.city)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, -15)
                            }
                        ))
                        .font(.headline)
                        
                    }.imageScale(.large)
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle("AR City Tour")
            .navigationDestination(for: Tour.self) { tour in
                
            }
        }
    }
}

#Preview {
    ContentView()
}


