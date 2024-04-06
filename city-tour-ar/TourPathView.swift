//
//  TourPathView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI

struct TourPathView: View {
    let tasks: [Task]
    @State var currentTaskIndex: Int
    
    var body: some View {
        VStack {
            Text("Tour progress")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .padding()
                .padding(.top, 30)
            
            List(Array(tasks.enumerated()), id: \.element) { index, task in
                TaskView(index: index + 1, description: task.description, isHighlighted: index == currentTaskIndex)
                    .listRowSeparator(.hidden)
            }.listStyle(.plain)
        }
    }
}

#Preview {
    TourPathView(tasks: tasks, currentTaskIndex: 0)
}
