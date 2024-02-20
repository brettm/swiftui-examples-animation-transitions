//
//  ListView.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//
import SwiftUI

public struct TransitionList: View {

    @Binding public var items: [Transition]
    @Binding public var viewStack: [Transition]
    @Binding public var isTransitioning: Bool
    
    @State private var showDetail = false
    @State private var animateHeroKeyframes = false
    @State private var showDefaultImagePicker = false
    
    @Namespace private var namespace
    
    public var body: some View {
        if self.showDetail {
            TransitionDetail(transition: Transition(type: .modifiedGeometry, systemSymbolName: "triangle"),
                             isTranstioning: $isTransitioning,
                             namespace: self.namespace
            )
            .contentShape(Rectangle())
            .background(.blue)
            .onTapGesture {
                withAnimation { self.showDetail = false }
            }
        }
        else {
            GeometryReader { proxy in
                NavigationStack(path: $viewStack) {
                    List {
                        Section {
                            ForEach($items) { $item in
                                NavigationLink(value: item) {
                                    HStack {
                                        TransitionImage(systemImageName: item.systemSymbolName)
                                            .anchorPreference(
                                                key: BoundsAnchorPreferenceKey.self,
                                                value: .bounds
                                            ) { boundsAnchor in
                                                return [item.id: boundsAnchor]
                                            }
                                            .frame(maxWidth: 40, maxHeight: 20)
                                            .contentTransition(.symbolEffect)
                                        Text(item.type.name)
                                    }
                                }
                            }
                        }
                        header: { Text("Navigation Stack") }
                        Section {
                            Button {
                                withAnimation {
                                    self.showDetail = true
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "triangle")
                                        .matchedGeometryEffect(
                                            id: TransitionType.modifiedGeometry,
                                            in: self.namespace
                                        )
                                    Text(TransitionType.modifiedGeometry.name)
                                }
                            }
                        }
                        header: { Text("View") }
                        Section {
                            Button {
                                self.showDefaultImagePicker = true
                            } label: {
                                HStack {
                                    Text("Default Image")
                                    Spacer()
                                    if let defaultTransition = items.first(where: { transition in
                                        transition.type == .none
                                    }) {
                                        TransitionImage(systemImageName: defaultTransition.systemSymbolName)
                                        .frame(maxHeight: 20)
                                    }
                                }
                            }
                        }
                        header: { Text("Settings") }
                    }
                    .navigationDestination(for: Transition.self) { transition in
                        TransitionDetail(transition: transition,
                                         isTranstioning: $isTransitioning,
                                         namespace: self.namespace)
                    }
                    .navigationTitle("Transitions")
                }
                .sheet(isPresented: $showDefaultImagePicker) {
                    SystemImagePicker(selectedImageName: $items.first!.systemSymbolName)
                        .presentationDetents([.medium])
                }
            }
        }
    }
}





