//
//  TransitionViewModel.swift
//  TransitionExample
//
//  Created by Brett Meader on 01/12/2023.
//

import SwiftUI

@Observable
public class TransitionViewModel: Codable, ObservableObject {
    
    public var items: [Transition] = AppState.transitionItems
    
    enum CodingKeys: String, CodingKey {
        case selectedSystemImage
        case transitionPathIds
    }
    
    internal init(items: [Transition] = AppState.transitionItems) {
        self.items = items
    }
    
    public var jsonData: Data? {
        get {
            return try? JSONEncoder().encode(self)
        }
        set {
            guard
                let data = newValue,
                let cached = try? JSONDecoder().decode(type(of: self), from: data)
            else {
                return
            }
            self.items = cached.items.sorted(by: { $0.id < $1.id })
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(items.first(where: { $0.type == .none })?.systemSymbolName, forKey: .selectedSystemImage)
    }
    
    required public init(from decoder: Decoder) throws {
        let decoded = try TransitionViewModel.decode(from: decoder)
        self.items = decoded.items
    }
    
    private static func decode(from decoder: Decoder) throws -> TransitionViewModel {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let selectedImage = try container.decodeIfPresent(String.self, forKey: .selectedSystemImage)
       
        let data: [Int: Transition] = AppState.transitionItems.reduce(into: [:]) { partialResult, transition in
            var transition = transition
            if let selectedImage, transition.type == .none {
                transition.systemSymbolName = selectedImage
            }
            partialResult[transition.id] = transition
        }        
        return TransitionViewModel(items: Array(data.values))
    }
}
