//
//  SessionStore.swift
//  DailyRoundsAssignment
//
//  Created by Ganpat Jangir on 09/04/25.
//

import Foundation

class SessionStore: ObservableObject {
    static let shared = SessionStore()

    @Published var sessions: [Session] = [] {
        didSet {
            saveSessions()
        }
    }

    private let filename = "sessions.json"

    private init() {
        loadSessions()
    }

    // MARK: - Public Methods

    func addSession(_ session: Session) {
        sessions.insert(session, at: 0)
    }

    // MARK: - Persistence

    private func fileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    }

    private func saveSessions() {
        do {
            let data = try JSONEncoder().encode(sessions)
            try data.write(to: fileURL())
        } catch {
            print("Failed to save sessions:", error)
        }
    }

    private func loadSessions() {
        let url = fileURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Session].self, from: data)
            self.sessions = decoded
        } catch {
            print("Failed to load sessions:", error)
        }
    }
}
