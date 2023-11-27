//
//  ListView.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//
import SwiftUI

@Observable
class ListViewModel {
    var items: [TransitionItem] = AppState.transitionItems
}

struct BoundsAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { _, new in
            return new
        }
    }
}

struct ListView: View {
    @Namespace var namespace
    
    @State var viewModel = ListViewModel()
    @State var viewStack: [TransitionItem] = []
    
    @State var showDetail = false
    @State var isTransitioning = false
    
    let transitionDelay = UInt64(1E+9)
    
    var body: some View {
        if self.showDetail {
            TransitionDetail(transition: TransitionItem(type: .modifiedGeometry),
                             namespace: self.namespace,
                             animationDelay: transitionDelay,
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
                            ForEach(viewModel.items, id: \.id) { item in
                                VStack {
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
                            }
                        } footer: {
                            VStack {
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
                            }
                        }
                    }
                    .navigationDestination(for: TransitionItem.self) { transition in
                        TransitionDetail(transition: transition,
                                         namespace: self.namespace,
                                         animationDelay: transitionDelay,
                                         isTranstioning: $isTransitioning)
                    }
                }
                .overlayPreferenceValue(BoundsAnchorPreferenceKey.self) { value in
                    if
                        let item = viewStack.last,
                        item.type != .none {
                        
                        GeometryReader { metrics in
                            if let anchor = value[item.id]{
                                let rect = metrics[anchor]
                                TransitionImageView(systemImageName: item.type.systemImageName)
                                    .frame(width: rect.size.width, height: rect.size.height)
                                    .position(x: rect.midX, y: rect.midY)
                                    .animation(.snappy(duration: 1.0, extraBounce: 0), value: rect)
                                    .opacity(isTransitioning ? 1 : 0)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TransitionImageView: View {
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}


struct TransitionDetail: View {
    var transition: TransitionItem
    var namespace: Namespace.ID
    var animationDelay: UInt64
    @Binding var isTranstioning: Bool
    
    @State private var animateImage: Bool = false
    
    private var hidesImage: Bool {
        if transition.type == .hero { return isTranstioning }
        return false
    }
    
    var body: some View {
        GeometryReader{ metrics in
            VStack {
                Spacer()
                TransitionImageView(systemImageName: transition.type.systemImageName)
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
                try? await Task.sleep(nanoseconds: animationDelay)
                animateImage = true
                isTranstioning = false
            }
        }
    }
}
