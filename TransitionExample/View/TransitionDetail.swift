//
//  TransitionView.swift
//  TransitionExample
//
//  Created by Brett Meader on 27/11/2023.
//

import SwiftUI

private struct AnimationValues {
    var scale = 1.0
    var offset = CGSize.zero
    var angle = Angle.zero
    var yRotation = Angle.zero
}

private enum AnimationPhase: String, CaseIterable, Identifiable {
    var id: String { return self.rawValue }
    case initial
    case squash
    case squeeze
}

@Observable
private class TransitionDetailViewModel {
    var animateImage: Bool = false
    var animateKeyframes: Bool = false
    var animatePhases: Bool = false
    var currentPhase: AnimationPhase = .initial
}

public struct TransitionDetail: View {
    
    public var transition: Transition
    @Binding public var isTranstioning: Bool
    
    @State private var viewModel = TransitionDetailViewModel()

    private(set) var namespace: Namespace.ID
    
    private var hidesImage: Bool {
        if transition.type == .hero { return isTranstioning }
        return false
    }
    
    public var body: some View {
        GeometryReader{ metrics in
            VStack {
                Spacer()
                TransitionImage(systemImageName: transition.systemSymbolName)
                    .matchedGeometryEffect(id: transition.type, in: self.namespace)
                    .frame(width: metrics.size.width, height: metrics.size.height * 0.33)
                    .opacity(hidesImage ? 0.0 : 1.0)
                    .anchorPreference(
                        key: BoundsAnchorPreferenceKey.self,
                        value: .bounds
                    ) { boundsAnchor in
                        return [transition.id: boundsAnchor]
                    }
                    .symbolEffect(.bounce, value: viewModel.animateImage ? 1 : 0)
                    .phaseAnimator(AnimationPhase.allCases, trigger: viewModel.animatePhases) { content, phase in
                        content.scaleEffect(
                            CGSize(width: phase == .squeeze ? 0.4 : 1.0,
                                   height: phase == .squash ? 0.4 : 1.0))
                    } animation:{ phase in
                        viewModel.currentPhase = phase
                        return .spring
                    }
                    .keyframeAnimator(initialValue: AnimationValues(), trigger: viewModel.animateKeyframes) { content, value in
                        content
                            .rotationEffect(value.angle)
                            .rotation3DEffect(value.yRotation, axis: (0, 1, 0))
                            .scaleEffect(value.scale)
                            .offset(value.offset)
                    } keyframes: { value in
                        KeyframeTrack(\.angle) {
                            CubicKeyframe(.radians(Double.pi / 6), duration: 0.5)
                            LinearKeyframe(.radians(Double.pi / 4), duration: 1.5)
                            MoveKeyframe(.zero)
                        }
                        KeyframeTrack(\.yRotation) {
                            LinearKeyframe(.zero, duration: 1.2)
                            MoveKeyframe(.radians(Double.pi))
                            LinearKeyframe(.radians(Double.pi * 0.75), duration: 1.5)
                            MoveKeyframe(.zero)
                        }
                        KeyframeTrack(\.offset) {
                            SpringKeyframe(CGSize(width: 0, height: 30), duration: 0.1, spring: .bouncy)
                            SpringKeyframe(CGSize(width: metrics.size.width, height: -metrics.size.height * 0.25), duration: 1.2)
                            CubicKeyframe(CGSize(width: -metrics.size.width, height: -metrics.size.height * 0.2), duration: 1.5)
                            SpringKeyframe(CGSize(width: 0, height: -metrics.size.height * 0.2), duration: 2, spring: .snappy)
                            CubicKeyframe(CGSize(width: 0, height: 0), duration: 1.5)
                            SpringKeyframe(CGSize(width: 0, height: 10), duration: 0.1, spring: .bouncy)
                            SpringKeyframe(CGSize(width: 0, height: -5), duration: 0.1, spring: .bouncy)
                            SpringKeyframe(.zero, duration: 0.1, spring: .bouncy)
                        }
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(1, duration: 1.3)
                            MoveKeyframe(0.8)
                            LinearKeyframe(0.1, duration: 1.2)
                            LinearKeyframe(1.0, duration: 1.5)
                        }
                    }
                    .navigationTitle(transition.type.name)
                Spacer()
                
                if transition.type == .hero {
                    Button { 
                        viewModel.animateKeyframes.toggle()
                    } label: {
                        Text("Animate Keyframes")
                    }
                    .buttonStyle(.bordered)
                }
            
                if transition.type == .none {
                    VStack(alignment: .leading) {
                        Text("Phase Animations").font(.headline).frame(alignment: .leading)
                        Picker("Phase Animations", selection: $viewModel.currentPhase) {
                            ForEach(AnimationPhase.allCases) { phase in
                                Text(phase.rawValue.capitalized).tag(phase)
                            }
                        }
                        .pickerStyle(.segmented)
                        .allowsHitTesting(false)
                    }
                    .padding(20)
                    Spacer()
                    Button {
                        viewModel.animatePhases.toggle()
                    } label: {
                        Text("Animate Phases")
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
            }
        }
        .onAppear {
            isTranstioning = true
            Task {
                try? await Task.sleep(nanoseconds: transition.duration.nanoSeconds)
                viewModel.animateImage = true
                isTranstioning = false
            }
        }
    }
}
