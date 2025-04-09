//
//  HomeView.swift
//  DailyRoundsAssignment
//
//  Created by Ganpat Jangir on 09/04/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let mode = vm.currentMode, vm.isFocusing {
                    Text("Focusing: \(mode.rawValue)")
                        .font(.largeTitle)
                    Text(vm.timerString)
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                    Text("Points: \(vm.points)")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack { ForEach(vm.badges) { Text($0.emoji).font(.largeTitle) } }
                    }
                    Button("Stop Focusing") { vm.stopFocus() }
                        .padding()
                        .frame(width: 240.0,height: 50.0)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else {
                    Text("Select Your Faourite Focus Mode")
                        .font(.title2)
                        .padding(.bottom, 50)
                    ForEach(FocusMode.allCases) { mode in
                        Button(mode.rawValue) { vm.startFocus(mode: mode) }
                            .font(.title3.bold())
                            .padding()
                            .frame(width: 240.0, height: 50.0)
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                Spacer()
                if self.vm.isFocusing == false {
                    NavigationLink("Profile", destination: ProfileView())
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Focus App")
        }
    }
}

#Preview {
    HomeView()
}
