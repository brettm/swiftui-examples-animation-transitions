//
//  ListView.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//
import SwiftUI

public struct BoundsAnchorPreferenceKey: PreferenceKey {
    public static var defaultValue: [String: Anchor<CGRect>] = [:]
    public static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { _, new in
            return new
        }
    }
}

@Observable
public class TransitionListViewModel {
    var items: [TransitionItem] = AppState.transitionItems
}

public struct TransitionList: View {
    
    @State private var viewModel = TransitionListViewModel()
    @State private var viewStack: [TransitionItem] = []
    @State private var showDetail = false
    @State private var isTransitioning = false
    
    @Namespace private var namespace
    
    public var body: some View {
        if self.showDetail {
            TransitionDetail(transition: TransitionItem(type: .modifiedGeometry),
                             namespace: self.namespace,
                             isTranstioning: $isTransitioning)
                .onTapGesture {
                    withAnimation {
                        self.showDetail = false
                    }
                }
        }
        else {
            GeometryReader { proxy in
                NavigationStack(path: $viewStack) {
                    List {
                        Section {
                            ForEach(viewModel.items) { item in
                                NavigationLink(value: item) {
                                    HStack {
                                        Image(systemName: item.type.systemImageName)
                                            .anchorPreference(
                                                key: BoundsAnchorPreferenceKey.self,
                                                value: .bounds
                                            ) { boundsAnchor in
                                                return [item.id: boundsAnchor]
                                            }
                                        Text(item.type.name)
                                    }
                                }
                            }
                        } footer: {
                            Button {
                                withAnimation {
                                    self.showDetail = true
                                }
                            } label: {
                                Image(systemName: TransitionType.modifiedGeometry.systemImageName)
                                    .matchedGeometryEffect(
                                        id: TransitionType.modifiedGeometry,
                                        in: self.namespace
                                    )
                                Text(TransitionType.modifiedGeometry.name)
                            }
                            .padding(.top)
                        }
                    }
                    .navigationDestination(for: TransitionItem.self) { transition in
                        TransitionDetail(transition: transition,
                                         namespace: self.namespace,
                                         isTranstioning: $isTransitioning)
                    }
                }
                .overlayPreferenceValue(BoundsAnchorPreferenceKey.self) { value in
                    if
                        let item = viewStack.last,
                        item.type == .hero {
                        
                        GeometryReader { metrics in
                            if let anchor = value[item.id]{
                                let rect = metrics[anchor]
                                TransitionImage(systemImageName: item.type.systemImageName)
                                    .frame(width: rect.size.width, height: rect.size.height)
                                    .position(x: rect.midX, y: rect.midY)
                                    .animation(.snappy(duration: item.duration, extraBounce: 0), value: rect)
                                    .opacity(isTransitioning ? 1 : 0)
                            }
                        }
                    }
                }
            }
        }
    }
}





