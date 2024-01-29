//
//  TransitionItem.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//

import SwiftUI

public enum TransitionType: Int {
    case none
    case hero
    case modifiedGeometry
    
    var name: String {
        switch(self) {
        case .none: return "Default"
        case .hero: return "Hero"
        case .modifiedGeometry: return "Modified Geometry"
        }
    }
}

public struct Transition: Identifiable, Equatable, Hashable {
    public var id: Int {
        return type.rawValue
    }
    public var type: TransitionType = .none
    public var systemSymbolName: String
    public var duration: TimeInterval = TimeInterval(0.75)
}
