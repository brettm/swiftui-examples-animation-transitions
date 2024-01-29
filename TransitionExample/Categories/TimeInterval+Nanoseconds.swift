//
//  TimeInterval+Nanoseconds.swift
//  TransitionExample
//
//  Created by Brett Meader on 27/11/2023.
//

import Foundation

extension TimeInterval {
    public var nanoSeconds: UInt64 {
        UInt64(self * 1E+9)
    }
}
