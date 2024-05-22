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

struct TaskView : View {
    let index: Int
    let description: String
    let isCompleted: Bool
    let isHighlighted: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            CheckmarkView(textView: AnyView(Text("#\(index)")), isCompleted: isCompleted)
                .fontDesign(.monospaced)
                .bold()
                .font(.system(size: 22))
        
            Text(description)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(.accent.opacity(isHighlighted ? 1 : 0.5))
        .cornerRadius(10)
        .foregroundStyle(.white)
    }
}

#Preview {
    TaskView(index: 1, description: "Find the nearest museum!", isCompleted: false, isHighlighted: true)
}
