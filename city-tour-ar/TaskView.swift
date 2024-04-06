//
//  TaskView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI

struct CheckmarkView: View {
    
    let textView: AnyView
    @State var isCompleted = false
    
    var body: some View {
        HStack(spacing: 20) {
            textView
            
            Spacer()
            
            Image(
                systemName: isCompleted ? "checkmark.square" : "square"
            )
        }
    }
}

struct TaskView : View {
    
    let index: Int
    let description: String
    
    @State var isCompleted = false
    @State var isHighlighted = false
    
    var body: some View {
        VStack(spacing: 20) {
            CheckmarkView(textView: AnyView(Text("Task \(index)")))
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

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        })
    }
}

#Preview {
    TaskView(index: 1, description: "Find the nearest museum!")
}
