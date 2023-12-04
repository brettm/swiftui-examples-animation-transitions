//
//  TransitionView.swift
//  TransitionExample
//
//  Created by Brett Meader on 27/11/2023.
//

import SwiftUI

public struct TransitionDetail: View {
    public var transition: Transition
    private(set) var namespace: Namespace.ID
    @Binding public var isTranstioning: Bool
    
    @State private var animateImage: Bool = false
    
    private var hidesImage: Bool {
        if transition.type == .hero { return isTranstioning }
        return false
    }
    
    public var body: some View {
        GeometryReader{ metrics in
            VStack {
                Spacer()
                TransitionImage(systemImageName: transition.type.systemImageName)
                    .matchedGeometryEffect(id: transition.type, in: self.namespace)
                    .frame(width: metrics.size.width, height: metrics.size.height * 0.33)
                    .opacity(hidesImage ? 0.0 : 1.0)
                    .anchorPreference(
                        key: BoundsAnchorPreferenceKey.self,
                        value: .bounds
                    ) { boundsAnchor in
                        return [transition.id: boundsAnchor]
                    }
                    .symbolEffect(.bounce, value: animateImage ? 1 : 0)
                Spacer()
                Text(transition.type.name)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
        }
        .onAppear {
            isTranstioning = true
            Task {
                try? await Task.sleep(nanoseconds: transition.duration.nanoSeconds())
                animateImage = true
                isTranstioning = false
            }
        }
    }
}
