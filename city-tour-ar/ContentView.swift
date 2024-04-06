//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    var body: some View {
        NavigationStack {
            TourView(tasks: tasks)
                .navigationTitle("AR City Tour")
        }
    }

}

#Preview {
    ContentView()
}


