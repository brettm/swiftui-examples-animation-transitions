//
//  SystemImagePicker.swift
//  TransitionExample
//
//  Created by Brett Meader on 30/11/2023.
//

import SwiftUI

struct SystemImagePicker: View {
    
    @Binding var selectedImageName: String
    
    private let imageNames = AppState.supportedSystemImages
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 40) {
            ForEach(imageNames, id: \.hashValue) { name in
                TransitionImage(systemImageName: name)
                    .frame(maxHeight: 80.0)
                    .foregroundStyle(name == selectedImageName ? .blue : .primary)
                    .opacity(name == selectedImageName ? 1.0 : 0.3)
                    .scaleEffect(name == selectedImageName ? 1.0 : 0.6)
                    .symbolEffect(.bounce , value: name == selectedImageName ? 1.0 : 0.0)
                    .onTapGesture {
                        withAnimation(.spring) {
                            selectedImageName = name
                        }
                    }
            }
        }
        .padding(20)
    }
}
