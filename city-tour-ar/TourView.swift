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
    
    
    @State private var offset = CGSize.zero
    
    let tourName: String
    let tasks: [TourTask]
    
    init(tourName: String, tasks: [TourTask]) {
        self.tourName = tourName
        self.tasks = tasks
        
        self.taskCompletions = tasks.map{ task in false}
    }
    
    var body: some View {
        ZStack {
            ARViewContainer(
                taskCompletedCallback: { task in
                    if task == tasks[currentTaskIndex].name {
                        taskCompletions[currentTaskIndex] = true
                        currentTaskCompleted = true
                    } else {
                        for i in currentTaskIndex..<tasks.count {
                            if task == tasks[i].name {
                                taskCompletions[i] = true
                            }
                        }
                    }
                }
            ).edgesIgnoringSafeArea(.all)
    
            VStack {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("\(currentTaskIndex + (currentTaskCompleted ? 1 : 0))/\(tasks.count)")
                            .font(.system(size: 20))
                        
                        Text("completed")
                            .font(.caption)
                    }
                    .foregroundStyle(.accent)
                    .padding()
                    .background(.accent.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                if currentTaskCompleted {
                    Button {
                        nextTask()
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
                        task: tasks[currentTaskIndex],
                        index: currentTaskIndex + 1,
                        isCompleted: taskCompletions[currentTaskIndex],
                        isHighlighted: !currentTaskCompleted
                    )
                    .padding(.bottom, 30)
                    .offset(y: offset.height * 5)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.height > 0 {
                                    offset = gesture.translation
                                }
                            }
                            .onEnded { _ in
                                if offset.height > 30 {
                                    self.showingChallenge = false
                                } else {
                                    offset = .zero
                                }
                            }
                    )
                }
                
                HStack {
                    Button("Tour path", systemImage: "point.topleft.down.to.point.bottomright.curvepath") {
                        showingPath.toggle()
                    }
                    .padding()
                    .background(.accent.opacity(0.1))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Button("Task", systemImage: "list.clipboard") {
                        offset = .zero
                        showingChallenge = true
                    }
                    .padding()
                    .background(.accent.opacity(0.1))
                    .cornerRadius(10)
                    .opacity(showingChallenge ? 0 : 1)
                    
                    Spacer()
                    
                    Button("Map", systemImage: "map") {
                        showingMap.toggle()
                    }
                    .padding()
                    .background(.accent.opacity(0.1))
                    .cornerRadius(10)
                    
                }
                .imageScale(.large)
                .labelStyle(.titleAndIcon)
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $showingMap){
            MapView(
                tasks: tasks,
                currentTaskIndex: currentTaskIndex
            )
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
    
    private func nextTask() {
        if currentTaskIndex != tasks.count - 1 {
            currentTaskIndex += 1
            currentTaskCompleted = taskCompletions[currentTaskIndex]
        }
    }
}


#Preview {
    NavigationStack {
        TourView(tourName: "Tour", tasks: defaultTasks)
    }
}
