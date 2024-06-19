//
//  TourList.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 22/05/2024.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct TourList: View {
    let title: String
    let completed: Bool
    let tours: [Tour]
    let tasks: [TourTask]
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(.blue)
                    .padding()
                    .cornerRadius(10)
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .frame(height: 1)
                    .foregroundStyle(.blue)
                
            }.padding(.vertical)
            
            List(tours, id: \.self) { tour in
                NavigationLink {
                    TourView(tour: tour,
                             tasks: tour.taskNames.compactMap { name in
                        tasks.filter { task in
                            task.name == name
                        }.first
                    })
                } label: {
                    HStack {
                        Image(systemName: "map.circle.fill")
                            .foregroundStyle(.accent)
                            .padding(.trailing)
                        
                        CheckmarkView(textView: AnyView(
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(tour.name)
                                        .font(.headline)
                                    
                                    Text("\(tour.city)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 3)
                                }
                                
                                Spacer()
                            }.frame(maxWidth: .infinity)
                        ), isCompleted: completed)
                        
                    }
                    .imageScale(.large)

                }.padding(.horizontal, -5)
            }
            .listStyle(.plain)
            .overlay {
                if tours.isEmpty {
                    Text("No tours found")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
#Preview {
    TourList(title: "New list", completed: false, tours: [defaultTours[0]], tasks: defaultTasks)
}
