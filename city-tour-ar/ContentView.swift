//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import RealityKit
import ARKit


struct TourList: View {
    let title: String
    let completed: Bool
    @State var tours: [Tour]
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 20))
                    .foregroundColor(.accent)
                    .cornerRadius(20)
                    .fontDesign(.monospaced)
                Spacer()
            }.padding()
            
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
                            
                            VStack(alignment: .leading) {
                                Text(tour.name)
                                
                                Text("\(tour.city)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 3)
                            }
                        ), isCompleted: completed)
                        .font(.headline)
                        
                    }
                    .imageScale(.large)

                }
            }
            .listStyle(.plain)
            .overlay {
                if tours.isEmpty {
                    Text("No tours found")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct ContentView : View {
    
    @State var completedTours: [UUID] = [tours[0].id]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
//                Text("Choose your today's adventure!")
//                    .padding()
//                    .foregroundStyle(.secondary)
//                    .font(.system(size: 18))
                
                TourList(title: "New tours", completed: false, tours: tours.filter { tour in !completedTours.contains(tour.id)
                })
                
                TourList(title: "Completed tours", completed: true, tours: tours.filter { tour in completedTours.contains(tour.id)
                })
            }
            .navigationTitle("AR City Tour")
            .padding()
            .background(.accent.opacity(0.05))
        }
    }
}

#Preview {
    ContentView()
}


