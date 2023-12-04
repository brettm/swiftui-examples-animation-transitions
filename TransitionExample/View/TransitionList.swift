//
//  ListView.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//
import SwiftUI

//@Observable
//public class TransitionListViewModel {
//    var items: [Transition] = AppState.transitionItems
//}

public struct TransitionList: View {
    
    public var items: [Transition]
    @Binding public var viewStack: [Transition]
    @Binding public var isTransitioning: Bool
    
    @State private var showDetail = false
    @Namespace private var namespace
    
    public var body: some View {
        if self.showDetail {
            TransitionDetail(transition: Transition(type: .modifiedGeometry),
                             namespace: self.namespace,
                             isTranstioning: $isTransitioning)
            
            .contentShape(Rectangle())
            .background(.blue)
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
                            ForEach(items) { item in
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
                            HStack {
                                Spacer()
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
                                Spacer()
                            }
                            .padding(.top)
                        }
                    }
                    .navigationDestination(for: Transition.self) { transition in
                        TransitionDetail(transition: transition,
                                         namespace: self.namespace,
                                         isTranstioning: $isTransitioning)
                    }
                    .navigationTitle("Transitions")
                }
//                .overlayPreferenceValue(BoundsAnchorPreferenceKey.self) { value in
//                    if let item = viewStack.last,
//                        item.type == .hero {
//                        
//                        GeometryReader { metrics in
//                            if let anchor = value[item.id] {
//                                let rect = metrics[anchor]
//                                
//                                TransitionImage(systemImageName: item.type.systemImageName)
//                                    .rotation3DEffect(.radians(rotation), axis: (x: 0, y: 1, z: 0))
//                                    .animation(
//                                        .easeInOut(duration: item.duration * 0.9),
//                                        value: rotation
//                                    )
//                                    .opacity(isTransitioning ? 1 : 0)
//                                    .frame(width: rect.size.width, height: rect.size.height)
//                                    .position(x: rect.midX, y: rect.midY)
//                                    .animation(
//                                        .snappy(duration: item.duration, extraBounce: 0),
//                                        value: rect
//                                    )
//                                    .onAppear{
//                                        rotation += 2.0 * Double.pi
//                                    }
//                            }
//                        }
//                    }
//                }
            }
        }
    }
}





