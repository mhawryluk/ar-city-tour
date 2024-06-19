//
//  CreditsView.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 19/06/2024.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        Text("Created by Marcin Hawryluk\nAGH, 2024")
            .navigationTitle("Credits")
    }
}

#Preview {
    NavigationStack {
        CreditsView()
    }
}
