//
//  TransitionView.swift
//  TransitionExample
//
//  Created by Brett Meader on 29/11/2023.
//
import SwiftUI

public struct BoundsAnchorPreferenceKey: PreferenceKey {
    public static var defaultValue: [Int: Anchor<CGRect>] = [:]
    public static func reduce(value: inout [Int : Anchor<CGRect>], nextValue: () -> [Int : Anchor<CGRect>]) {
        let next = nextValue()
        value.merge(next) { _, new in
            return new
        }
    }
}

public struct TransitionView: View {
    
    @State private var viewModel = TransitionViewModel()
    @AppStorage("data") private var data: Data?
    
    @State var path: [Transition] = []
    @State private var isTransitioning: Bool = false
    
    public var body: some View {
        TransitionList(items: $viewModel.items, viewStack: $path, isTransitioning: $isTransitioning)
            .overlayPreferenceValue(BoundsAnchorPreferenceKey.self) { value in
                if let item = path.last,
                    item.type == .hero {
                    
                    GeometryReader { metrics in
                        if let anchor = value[item.id] {
                            let rect = metrics[anchor]
                            
                            TransitionImage(systemImageName: item.systemSymbolName)
                                .opacity(isTransitioning ? 1 : 0)
                                .frame(width: rect.size.width, height: rect.size.height)
                                .position(x: rect.midX, y: rect.midY)
                                .animation(
                                    .snappy(duration: item.duration, extraBounce: 0.1),
                                    value: rect
                                )
                        }
                    }
                }
            }
            .task {
                if let data = data {
                    viewModel.jsonData = data
                }
            }
            .onChange(of: viewModel.items) { _, _ in
                data = viewModel.jsonData
            }
    }
}

