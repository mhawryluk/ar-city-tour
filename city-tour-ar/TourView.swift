//
//  TourView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI

struct TourView : View {
    
    @State var showingChallenge = false
    @State var showingPath = false
    @State var showingMap = false
    
    @State var currentTaskIndex: Int = 0
    
    let tasks: [Task]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ARViewContainer().edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 0) {
                            Text("\(currentTaskIndex)/\(tasks.count)")
                                .font(.system(size: 25))
                            
                            Text("completed")
                                .font(.caption)
                        }
                        .foregroundStyle(.accent)
                        .bold()
                        .padding()
                        .background(.accent.opacity(0.1))
                        .cornerRadius(20)
//                        .border(.accent, width: 2)
                    }
                    
                    Spacer()
                    
                    if (showingChallenge) {
                        TaskView(
                            index: currentTaskIndex + 1,
                            description: tasks[currentTaskIndex].description,
                            isHighlighted: true
                        )
                            .padding(.bottom, 30)
                    }
                    
                }
                .padding()
                .frame(maxHeight: .infinity)
            }
            .navigationTitle("AR City Tour")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack(spacing: 20) {
                        
                        Button("Tour path", systemImage: "point.topleft.down.to.point.bottomright.curvepath") {
                            showingPath.toggle()
                        }

                        Button("Task", systemImage: "list.clipboard") {
                            showingChallenge.toggle()
                        }
                        
                        Button("Map", systemImage: "map") {
                            showingMap.toggle()
                        }
                    
                    }
                    .labelStyle(.titleAndIcon)
                }
            }
        }.sheet(isPresented: $showingMap){
            MapView()
                .padding()
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showingPath){
            TourPathView(tasks: tasks, currentTaskIndex: currentTaskIndex)
                .padding()
                .presentationDragIndicator(.visible)
        }
    }
}


#Preview {
    TourView(tasks: tasks)
}
