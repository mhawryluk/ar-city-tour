//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    @State var showingChallenge = true;
    
    var body: some View {
        NavigationStack {
            ZStack {
                ARViewContainer().edgesIgnoringSafeArea(.all)
                
                if (showingChallenge) {
                    ChallengeView()
                }
            }
            .navigationTitle("AR City Tour")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Challenge", systemImage: "list.clipboard") {
                            showingChallenge.toggle()
                        }
                        
                        Button("Map", systemImage: "map") {
                            
                        }
                        
                        Button("Progress", systemImage: "point.topleft.down.to.point.bottomright.curvepath") {
                            
                        }
                    }
                }
            }
        }
    }
}


struct ChallengeView : View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Challenge 1")
                .fontWeight(.black)
            
            Text("Find the nearest museum!")
        }
        .padding(30)
        .background(.accent)
        .cornerRadius(10)
        .foregroundStyle(.white)
    }
}


struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
