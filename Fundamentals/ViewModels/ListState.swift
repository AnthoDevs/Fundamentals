//
//  ListState.swift
//  Fundamentals
//
//  Created by Anthony on 8/23/26.
//

import Foundation

enum ListState: Equatable {
    case loading
    case empty
    case error
    case content
    case retryable
}
