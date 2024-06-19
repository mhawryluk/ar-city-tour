//
//  QuestionView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 17/06/2024.
//

import SwiftUI

struct QuestionView: View {
    let question: PoiQuestion
    
    @State var selectedOption: Int?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(question.question)
                .font(.title)
                .bold()
                .padding(.bottom)
            
            VStack {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    Text(option)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(selectedOption != nil && question.correctOption == index ? .white : .black)
                        .background(
                            selectedOption != nil && question.correctOption == index ? .blue : selectedOption != nil && selectedOption == index ? .accent : .accent.opacity(0.1))
                        .cornerRadius(15)
                        .onTapGesture {
                            if selectedOption == nil {
                                withAnimation {
                                    selectedOption = index
                                }
                            }
                        }
                }
            }
            
            if let selectedOption {
                Text(selectedOption == question.correctOption ? "Correct!" : "Wrong answer. Correct: \(question.options[question.correctOption])")
                    .font(.footnote)
            }
        }
        .padding()
        .padding(.vertical, 40)
    }
}

#Preview {
    QuestionView(question: PoiQuestion(question: "How many stars are there on the american flag?", options: ["1", "49", "51", "50"], correctOption: 3))
}
