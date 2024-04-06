//
//  MapView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 06/04/2024.
//

import SwiftUI
import MapKit

struct MapView : View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.061389, longitude: 19.938333), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    var body: some View {
        VStack {
            Text("Map")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .padding()
                .padding(.top, 30)
            
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
}

#Preview {
    MapView()
}

extension CLLocationCoordinate2D {
    static let mariacki = CLLocationCoordinate2D(latitude: 50.061667, longitude: 19.939444)
}
