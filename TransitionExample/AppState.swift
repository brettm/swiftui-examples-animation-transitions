//
//  Data.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//

import Foundation

class AppState {
    static let transitionItems: [TransitionItem] = {
        return [
            TransitionItem(
                type: .none
            ),
            TransitionItem(
                type: .hero
            )
        ]
    }()
}
