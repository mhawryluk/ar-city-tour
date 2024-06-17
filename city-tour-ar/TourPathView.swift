//
//  TourPathView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI

struct TaskSheetOption: Identifiable {
    var id = UUID()
    var type: String
    var task: TourTask
}

struct TourPathView: View {
    let tasks: [TourTask]
    
    @State var currentTaskIndex: Int
    @State private var taskSheetOption: TaskSheetOption? = nil
    
    var body: some View {
        VStack {
            Text("Tour progress")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .padding()
                .padding(.top, 30)
            
            
            List(Array(tasks.enumerated()), id: \.offset) { index, task in
                TaskView(
                    task: task,
                    index: index + 1,
                    isCompleted: index < currentTaskIndex,
                    isHighlighted: index == currentTaskIndex
                ) {
                    if index <= currentTaskIndex {
                        HStack {
                            if task.moreInfo != nil {
                                Button {
                                    taskSheetOption = TaskSheetOption(type: "moreInfo", task: task)
                                } label: {
                                    Label("Read more", systemImage: "text.book.closed")
                                        .labelStyle(.titleAndIcon)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            
                            if task.question != nil {
                                Button {
                                    taskSheetOption = TaskSheetOption(type: "question", task: task)
                                } label: {
                                    Label("Quiz", systemImage: "questionmark.square.dashed")
                                        .labelStyle(.titleAndIcon)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.bordered)
                          
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }.listStyle(.plain)
        }
        .sheet(item: $taskSheetOption, onDismiss: {
            taskSheetOption = nil
        }) { option in
            let _ = print(option)
            if option.type == "moreInfo" {
                if let info = option.task.moreInfo {
                    PoiInfoView(info: info)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
                
            } else if option.type == "question" {
                if let question = option.task.question {
                    QuestionView(question: question)
                        .presentationDetents([.fraction(0.7), .large])
                        .presentationDragIndicator(.visible)
                }
            }
            
        }
    }
}

#Preview {
    TourPathView(tasks: defaultTasks, currentTaskIndex: 0)
}
