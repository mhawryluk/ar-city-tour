//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import RealityKit
import MapKit
import ARKit

struct ContentView : View {
    
    @State var showingChallenge = false
    @State var showingMap = false
    
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

class ARCoordinator: NSObject, ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        // Perform tasks on the background thread
        DispatchQueue.global().async { [weak self] in
            
            // Check if the detected anchor is an ARImageAnchor
            if let imageAnchor = anchor as? ARImageAnchor {
                
                // Creating a plane geometry
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor.accent.withAlphaComponent(0.7)
                
                print(imageAnchor.referenceImage.name)
                
                // Creating a plane node
                let planeNode = SCNNode(geometry: plane)
                
                // Rotate the plane node 90 degrees counter clockwise
                planeNode.eulerAngles.x = -.pi / 2
                
                if let nodeName = imageAnchor.referenceImage.name {
                    print(nodeName)
                    if let nodeScene = self?.getNodeScene(name: nodeName) {
                        
                        print("nodeScene", nodeScene)
                        
                        // Adding nodes on the main thread
                        DispatchQueue.main.async {
                            planeNode.addChildNode(nodeScene)
                            node.addChildNode(planeNode)
                        }
                    }
                }
            }
        }
        
        return node
    }
    
    private func getNodeScene(name: String) -> SCNNode? {
        
        if let nodeScene = SCNScene(named: "art.scnassets/\(name).scn") {
            
            let node = nodeScene.rootNode
            print("first node found \(name)")
            return node
        }
        
        return nil
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}


struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        
        let sceneView = ARSCNView(frame: .zero)
        sceneView.showsStatistics = true
        sceneView.delegate = context.coordinator
        
        //        // Create a cube model
        //        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        //        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        //        let model = ModelEntity(mesh: mesh, materials: [material])
        //
        //        // Create horizontal plane anchor for the content
        //        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        //        anchor.children.append(model)
        //
        //        // Add the horizontal plane anchor to the scene
        //        arView.scene.anchors.append(anchor)
        
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        
        return sceneView
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    
    func makeCoordinator() -> ARCoordinator {
        ARCoordinator()
    }
    
}

#Preview {
    ContentView()
}

extension CLLocationCoordinate2D {
    static let mariacki = CLLocationCoordinate2D(latitude: 50.061667, longitude: 19.939444)
}
