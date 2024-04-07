//
//  TourView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI

struct TourView : View {
    
    @State var showingChallenge = true
    @State var showingPath = false
    @State var showingMap = false
    
    @State var currentTaskIndex: Int = 0
    @State var taskCompletions: [Bool]
    @State var currentTaskCompleted: Bool = false
    @State var allTasksCompleted: Bool = false
    
    let tourName: String
    let tasks: [Task]
    
    init(tourName: String, tasks: [Task]) {
        self.tourName = tourName
        self.tasks = tasks
        
        self.taskCompletions = tasks.map{ task in false}
    }
    
    var body: some View {
        ZStack {
            ARViewContainer(
                task: tasks[currentTaskIndex],
                taskCompletedCallback: {
                    taskCompletions[currentTaskIndex] = true
                    currentTaskCompleted = true
                }
            ).edgesIgnoringSafeArea(.all)
    
            VStack {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("\(currentTaskIndex + (currentTaskCompleted ? 1 : 0))/\(tasks.count)")
                            .font(.system(size: 25))
                        
                        Text("completed")
                            .font(.caption)
                    }
                    .foregroundStyle(.accent)
                    .bold()
                    .padding()
                    .background(.accent.opacity(0.1))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                if currentTaskCompleted {
                    Button {
                        if currentTaskIndex != tasks.count - 1 {
                            currentTaskIndex += 1
                            currentTaskCompleted = false
                        }
                    } label: {
                        Label("Next task", systemImage: "arrowshape.right.circle.fill")
                            .labelStyle(.titleAndIcon)
                            .imageScale(.large)
                            .font(.system(size: 20))
                            .padding(10)
     
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                if showingChallenge {
                    TaskView(
                        index: currentTaskIndex + 1,
                        description: tasks[currentTaskIndex].description,
                        isCompleted: taskCompletions[currentTaskIndex],
                        isHighlighted: !currentTaskCompleted
                    )
                    .padding(.bottom, 30)
                }
                
                HStack {
                    Button("Tour path", systemImage: "point.topleft.down.to.point.bottomright.curvepath") {
                        showingPath.toggle()
                    }
                    
                    Spacer()
                    
                    Button("Task", systemImage: "list.clipboard") {
                        showingChallenge.toggle()
                    }
                    
                    Spacer()
                    
                    Button("Map", systemImage: "map") {
                        showingMap.toggle()
                    }
                    
                }
                .imageScale(.large)
                .labelStyle(.titleAndIcon)
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $showingMap){
            MapView()
                .padding()
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showingPath){
            TourPathView(tasks: tasks, currentTaskIndex: currentTaskIndex)
                .padding()
                .presentationDragIndicator(.visible)
        }
        .alert(isPresented: $allTasksCompleted) {
            Alert (
                title: Text("Tour completed"),
                message: Text("Well done!")
            )
        }
        .navigationTitle(tourName)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        TourView(tourName: "Tour", tasks: tasks)
    }
}
