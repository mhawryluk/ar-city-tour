//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import RealityKit
import MapKit

struct ContentView : View {
    
    @State var showingChallenge = false
    @State var showingMap = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                ARViewContainer().edgesIgnoringSafeArea(.all)
                
                VStack {
                    if (showingChallenge) {
                        ChallengeView()
                    }
                    
                    if (showingMap) {
                        MapView()
                    }
                }.padding()
            }
            .navigationTitle("AR City Tour")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Challenge", systemImage: "list.clipboard") {
                            showingChallenge.toggle()
                        }
                        
                        Button("Map", systemImage: "map") {
                            showingMap.toggle()
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

struct MapView : View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.061389, longitude: 19.938333), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    var body: some View {
        Map {
            Annotation("Kościół Mariacki", coordinate: .mariacki) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.accent)
                    Text("⛪️")
                        .padding(5)
                }
            }
        }.mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .mapStyle(.hybrid(elevation: .realistic))
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

extension CLLocationCoordinate2D {
    static let mariacki = CLLocationCoordinate2D(latitude: 50.061667, longitude: 19.939444)
}
