//
//  ARViews.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import ARKit
import SceneKit
import UIKit
import RealityKit
import SwiftUI

class ARCoordinator: NSObject, ARSCNViewDelegate {
    
    let taskCompletedCallback: (String) -> Void
    
    init(taskCompletedCallback: @escaping (String) -> Void) {
        self.taskCompletedCallback = taskCompletedCallback
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        print("anchor: ", anchor)
        
        // Perform tasks on the background thread
        DispatchQueue.global().async { [self] in
            
            // Check if the detected anchor is an ARImageAnchor
            if let imageAnchor = anchor as? ARImageAnchor {
                
                // Creating a plane geometry
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.4)
                
                print("Detected image anchor: ", imageAnchor.referenceImage.name ?? "")
                
                let name = imageAnchor.referenceImage.name
                guard let taskName = name?.split(separator: "_").first else {
                    return
                }
                
                self.taskCompletedCallback(String(taskName))
                
                // Creating a plane node
                let planeNode = SCNNode(geometry: plane)
                
                // Rotate the plane node 90 degrees counter clockwise
                planeNode.eulerAngles.x = -.pi / 2
                
                
                print("taskName: ", taskName)
                if let nodeScene = self.getNodeScene(name: String(taskName)) {
                    
                    print("nodeScene", nodeScene)
                    
                    // Adding nodes on the main thread
                    DispatchQueue.main.async {
                        planeNode.addChildNode(nodeScene)
                        node.addChildNode(planeNode)
                    }
                }
            }
            
            if let objectAnchor = anchor as? ARObjectAnchor {
                print("Detected object anchor: ", objectAnchor.referenceObject.name ?? "")
                
                let name = objectAnchor.referenceObject.name
                guard let taskName = name?.split(separator: "_").first else {
                    return
                }
                
                self.taskCompletedCallback(String(taskName))
                
                print("taskName: ", taskName)
                if let nodeScene = self.getNodeScene(name: String(taskName)) {
                    
                    print("nodeScene", nodeScene)
                    
                    // Adding nodes on the main thread
                    DispatchQueue.main.async {
                        node.addChildNode(nodeScene)
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

    let taskCompletedCallback: (String) -> Void
    let referenceImages: Set<ARReferenceImage>
    let referenceObjects: Set<ARReferenceObject>
    
    func makeUIView(context: Context) -> some UIView {
        
        let sceneView = ARSCNView(frame: .zero)
        sceneView.showsStatistics = false
        sceneView.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.detectionObjects = referenceObjects
        
        print("configuration reference images", configuration.detectionImages ?? [])
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        return sceneView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    
    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(taskCompletedCallback: taskCompletedCallback)
    }
}
