//
//  TaskView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI

struct CheckmarkView: View {
    
    let textView: AnyView
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            textView
            
            Spacer()
            
            Image(
                systemName: isCompleted ? "checkmark.square" : "square"
            ).foregroundStyle(.secondary)
        }
    }
}

struct TaskView<Content: View> : View {
    let task: TourTask
    let index: Int
    let isCompleted: Bool
    let isHighlighted: Bool
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 20) {
            CheckmarkView(textView: AnyView(Text("#\(index)")), isCompleted: isCompleted)
                .fontDesign(.monospaced)
                .bold()
                .font(.system(size: 22))
        
            Text(task.description)
            
            content
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(Color.blue.opacity(isHighlighted ? 1 : 0.5))
        .cornerRadius(10)
        .foregroundStyle(.white)
    }
}

#Preview {
    VStack {
        TaskView(
            task: TourTask(name: "test", description: "Find the nearest museum"),
            index: 1,
            isCompleted: true,
            isHighlighted: true
        ) {
            
        }
        
        TaskView(
            task: TourTask(name: "test2", description: "Find the nearest museum"),
            index: 2,
            isCompleted: false,
            isHighlighted: false
        ) {
            
        }
    }
}
