//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import RealityKit
import ARKit
import FirebaseFirestore

struct App : View {
    
    @State var isLoading = true
    @State var tasks: [TourTask] = defaultTasks
    @State var tours: [Tour] = defaultTours
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var completedTours: [String] = ["l1"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                TourList(title: "New tours", completed: false, tours: tours.filter { tour in !completedTours.contains(tour.id)
                }, tasks: tasks)
                
                TourList(title: "Completed tours", completed: true, tours: tours.filter { tour in completedTours.contains(tour.id)
                }, tasks: tasks)
            }
            .navigationTitle("AR Tours")
            .padding()
        }.onAppear {
            Task {
                let db = Firestore.firestore()

                do {
                    let toursDocuments = try await db.collection("tours").getDocuments()
                    for document in toursDocuments.documents {
                        let data = try document.data(as: Tour.self)
                    
                        tours.append(data)
                    }
                    
                    let taskDocuments = try await db.collection("tasks").getDocuments()
                    for document in taskDocuments.documents {
                        let data = try document.data(as: TourTask.self)
                    
                        tasks.append(data)
                    }
                    
                    
                } catch {
                    print("Error getting document: \(error)")
                }
                
                print(tours, tasks)
                isLoading = false
            }
        }
    }
}

#Preview {
    App()
}

