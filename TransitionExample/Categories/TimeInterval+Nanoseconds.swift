//
//  TimeInterval+Nanoseconds.swift
//  TransitionExample
//
//  Created by Brett Meader on 27/11/2023.
//

import Foundation

extension TimeInterval {
    public func nanoSeconds() -> UInt64 {
        return UInt64(self * 1E+9)
    }
}
