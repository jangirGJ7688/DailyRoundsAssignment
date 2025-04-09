//
//  FocusViewModel.swift
//  DailyRoundsAssignment
//
//  Created by Ganpat Jangir on 09/04/25.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var currentMode: FocusMode? = nil
    @Published var startTime: Date? = nil
    @Published var timerString: String = "00:00"
    @Published var points: Int = 0
    @Published var badges: [Badge] = []
    @Published var isFocusing: Bool = false

    private var timer: AnyCancellable?
    private var badgeTimer: AnyCancellable?

    func startFocus(mode: FocusMode) {
        currentMode = mode
        startTime = Date()
        isFocusing = true
        points = 0
        badges = []
        startTimer()
        startBadgeTimer()
    }

    func stopFocus() {
        guard let start = startTime else { return }
        let duration = Date().timeIntervalSince(start)
        SessionStore.shared.addSession(Session(mode: currentMode!, startTime: start, duration: duration, points: points, badges: badges))
        reset()
    }

    private func reset() {
        timer?.cancel()
        badgeTimer?.cancel()
        currentMode = nil
        startTime = nil
        timerString = "00:00"
        isFocusing = false
    }

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            let interval = Date().timeIntervalSince(start)
            self.timerString = interval >= 3600 ? self.formatTime(interval, withHours: true) : self.formatTime(interval, withHours: false)
        }
    }

    private func startBadgeTimer() {
        badgeTimer = Timer.publish(every: 120, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            self.points += 1
            if let badge = self.randomBadge() {
                self.badges.append(badge)
            }
        }
    }

    private func randomBadge() -> Badge? {
        guard let category = Constants.badges.randomElement(), let emoji = category.randomElement() else { return nil }
        return Badge(emoji: emoji)
    }

    private func formatTime(_ interval: TimeInterval, withHours: Bool) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = withHours ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval) ?? "--:--"
    }
}
