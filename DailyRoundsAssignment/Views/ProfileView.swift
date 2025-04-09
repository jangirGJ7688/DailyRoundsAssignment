//
//  ProfileView.swift
//  DailyRoundsAssignment
//
//  Created by Ganpat Jangir on 09/04/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var sessionStore = SessionStore.shared
    @StateObject var vm = ProfileViewModel()

    var body: some View {
        VStack(spacing: 16) {
            PhotosPicker(selection: $vm.selectedItem, matching: .images) {
                            if let image = vm.profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            } else {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onChange(of: vm.selectedItem) { _ in
                            vm.handleImageSelection()
                        }
            TextField("Enter your name", text: $vm.userName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
            Text("Total Points: \(sessionStore.sessions.reduce(0) { $0 + $1.points })")
            Text("Badges: \(sessionStore.sessions.flatMap { $0.badges }.map { $0.emoji }.joined(separator: " "))")
                .multilineTextAlignment(.center)

            Text("Recent Sessions")
                .font(.headline)
                .padding(.top)

            if sessionStore.sessions.count == 0 {
                Text("No session history yet!")
                    .font(.headline)
                Spacer()
            } else {
                List(sessionStore.sessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.mode.rawValue).font(.headline)
                        Text("Duration: \(formatTime(session.duration))")
                        Text("Points: \(session.points)")
                        Text("Started: \(session.startTime.formatted(date: .abbreviated, time: .shortened))")
                    }
                }
            }
        }
        .padding()
    }

    func formatTime(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        return formatter.string(from: interval) ?? "--"
    }
}

#Preview {
    ProfileView()
}
