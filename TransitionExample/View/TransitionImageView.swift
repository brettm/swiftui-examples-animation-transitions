//
//  TransitionImageView.swift
//  TransitionExample
//
//  Created by Brett Meader on 27/11/2023.
//

import SwiftUI

public struct TransitionImage: View {
    public var systemImageName: String
    public var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
