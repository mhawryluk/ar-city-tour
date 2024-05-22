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
    let task:  TourTask
    let taskCompletedCallback: () -> Void
    
    init(task: TourTask, taskCompletedCallback: @escaping () -> Void) {
        self.task = task
        self.taskCompletedCallback = taskCompletedCallback
    }
    

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        // Perform tasks on the background thread
        DispatchQueue.global().async { [self] in
            
            // Check if the detected anchor is an ARImageAnchor
            if let imageAnchor = anchor as? ARImageAnchor {
                
                // Creating a plane geometry
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.7)
                
                print("Detected anchor: ", imageAnchor.referenceImage.name)
                
                if imageAnchor.referenceImage.name == self.task.name {
                    self.taskCompletedCallback()
                }
                
                // Creating a plane node
                let planeNode = SCNNode(geometry: plane)
                
                // Rotate the plane node 90 degrees counter clockwise
                planeNode.eulerAngles.x = -.pi / 2
                
                if let nodeName = imageAnchor.referenceImage.name {
                    print("nodeName: ", nodeName)
                    if let nodeScene = self.getNodeScene(name: nodeName) {
                        
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
    
    let task: TourTask
    let taskCompletedCallback: () -> Void
    
    func makeUIView(context: Context) -> some UIView {
        
        let sceneView = ARSCNView(frame: .zero)
        sceneView.showsStatistics = false
        sceneView.delegate = context.coordinator
        
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
        ARCoordinator(task: task, taskCompletedCallback: taskCompletedCallback)
    }
}
