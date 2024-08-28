//
//  ContentView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 18/10/2023.
//

import SwiftUI
import FirebaseFirestore
import ARKit


var referenceImages: Set<ARReferenceImage> = []
var referenceObjects: Set<ARReferenceObject> = []

struct App : View {
    
    @State var isLoading = true
    @State var tasks: [TourTask] = defaultTasks
    @State var tours: [Tour] = defaultTours
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if isLoading {
                    ProgressView("Fetching data...")
                } else {
                    
                    let completedTours = tours.filter { tour in
                        UserDefaults.standard.bool(forKey: "t_\(tour.id)")
                    }
                    
                    TourList(title: "New tours", completed: false, tours: tours.filter { tour in !completedTours.contains(tour)
                    }, tasks: tasks)
                    
                    
                    TourList(title: "Completed tours", completed: true, tours: completedTours, tasks: tasks)
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button {
                            fetchTourData()
                        } label: {
                            Label("Refresh tour data", systemImage: "arrow.clockwise")
                        }
                        
                        
                        NavigationLink {
                            CreditsView()
                        } label: {
                            Label("Credits", systemImage: "info")
                        }
                        
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationTitle("AR Tours")
            .padding()
            .onAppear {
                //                    purgeData()
                fetchTourData()
            }
        }
    }
    
    private func fetchTourData() {
        isLoading = true
        tours = defaultTours
        
        Task {
            let db = Firestore.firestore()
            
            do {
                let toursDocuments = try await db.collection("tours").getDocuments()
                
                for document in toursDocuments.documents {
                    let data = try document.data(as: Tour.self)
                    
                    tours.append(data)
                }
                
                let taskDocuments = try await db.collection("tasks").getDocuments()
                for document in taskDocuments.documents {
                    let data = try document.data(as: TourTask.self)
                    
                    tasks.append(data)
                }
                
                StorageHelper.removeAllReferences()
                referenceImages = []
                referenceObjects = []
                
                for task in self.tasks {
                    print("downloading image refs for: ", task.name)
                    
                    for refImageDescriptor in task.referenceImages ?? [] {
                        StorageHelper.asyncDownload(relativePath: "referenceImages/\(refImageDescriptor.fileName)") { fileUrl in
                            
                            let ref = StorageHelper.createResourceImage(relativePath: "referenceImages/\(refImageDescriptor.fileName)", physicalWidth: refImageDescriptor.physicalWidth)
                            
                            ref?.name = "\(task.name)_\(refImageDescriptor.fileName)"
                            
                            if let ref {
                                referenceImages.insert(ref)
                            }
                        }
                    }
                    
                    for refObjectDescriptor in task.referenceObjects ?? [] {
                        StorageHelper.asyncDownload(relativePath: "referenceObjects/\(refObjectDescriptor.fileName)") { fileUrl in
                            
                            let ref = StorageHelper.createResourceObject(relativePath: "referenceObjects/\(refObjectDescriptor.fileName)")
                            
                            ref?.name = "\(task.name)_\(refObjectDescriptor.fileName)"
                            
                            if let ref {
                                referenceObjects.insert(ref)
                            }
                        }
                    }
                    
                    if let model = task.sceneModel {
                        StorageHelper.asyncDownload(
                            relativePath: "models/\(model.fileName)") {
                                fileUrl in print(fileUrl)
                        }
                    }
                    
                    for imageId in task.moreInfo?.imageIds ?? [] {
                        StorageHelper.asyncDownload(
                            relativePath: "moreInfoPictures/\(imageId)") {
                                fileUrl in print(fileUrl)
                        }
                    }
                }
                
            } catch {
                print("Error getting document: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func purgeData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key.starts(with: "t_") {
                defaults.removeObject(forKey: key)
            }
        }
    }
}

#Preview {
    App()
}

