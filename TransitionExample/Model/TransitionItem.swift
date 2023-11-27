//
//  TransitionItem.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//

import Foundation

public enum TransitionType {
    case none
    case hero
    case modifiedGeometry
    
    var name: String {
        switch self {
        case .none: return "Default"
        case .hero: return "Hero"
        case .modifiedGeometry: return "Modified Geometry"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .none: return "play.rectangle"
        case .hero: return "trophy"
        case .modifiedGeometry: return "triangle"
        }
    }
}

public struct TransitionItem: Identifiable, Equatable, Hashable {
    public var id: String {
        return type.name
    }
    public var type: TransitionType = .none
    public var duration: TimeInterval = TimeInterval(1.0)
}
