//
//  Data.swift
//  TransitionExample
//
//  Created by Brett Meader on 21/11/2023.
//

import Foundation

class AppState {
    static let transitionItems: [Transition] = {
        return [
            Transition(
                type: .none,
                systemSymbolName: "play.rectangle"
            ),
            Transition(
                type: .hero,
                systemSymbolName: "figure.run"
            )
        ]
    }()
    
    static let supportedSystemImages: [String] = {
        return [
            "paperplane",
            "newspaper",
            "personalhotspot.circle",
            "shareplay",
            "person.wave.2",
            "figure.walk.motion",
            "play.rectangle",
            "timelapse",
            "sun.haze.fill"
        ]
    }()
}
