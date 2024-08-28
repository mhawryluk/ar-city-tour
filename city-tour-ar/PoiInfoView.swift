//
//  PoiInfoView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 17/06/2024.
//

import SwiftUI

struct PoiInfoView: View {
    let info: PoiInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(info.title)
                .font(.title)
                .bold()
            
            HStack {
                Text(info.description)
            }
            .padding()
            .background(.accent.opacity(0.1))
            .cornerRadius(20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(info.imageIds, id: \.self) { name in
                        (StorageHelper.getImage(relativePath: "moreInfoPictures/\(name)") ?? Image(String(name.split(separator: ".").first!)))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 250)
                    }
                }
            }
            
        }
        .padding()
        .padding(.vertical, 40)
    }
}

#Preview {
    PoiInfoView(info: PoiInfo(
        title: "Jacek Malczewski",
        description: "Jacek Malczewski (ur. 14 lipca 1854 w Radomiu, zm. 8 października 1929 w Krakowie) – polski malarz, jeden z głównych przedstawicieli symbolizmu przełomu XIX i XX wieku.",
        imageIds: ["malczewski.jpg", "malczewski_art_1.jpg", "malczewski_art_2.jpg"])
    )
}
