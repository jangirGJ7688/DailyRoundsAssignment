//
//  Models.swift
//  DailyRoundsAssignment
//
//  Created by Ganpat Jangir on 09/04/25.
//

import SwiftUI

enum FocusMode: String, CaseIterable, Identifiable, Codable {
    case Work, Play, Rest, Sleep
    var id: String { rawValue }
}

struct Badge: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    let emoji: String
}


struct Session: Identifiable, Codable {
    var id = UUID().uuidString
    let mode: FocusMode
    let startTime: Date
    let duration: TimeInterval
    let points: Int
    let badges: [Badge]
}
