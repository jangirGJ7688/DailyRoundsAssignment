//
//  ProfileViewModel.swift
//  DailyRoundsAssignment
//
//  Created by Ganpat Jangir on 09/04/25.
//


import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject {
    @AppStorage(Constants.usernameKey) var userName: String = "Username"
    @AppStorage(Constants.userImageKey) var profileImageData: Data?

    @Published var selectedItem: PhotosPickerItem?
    @Published var profileImage: UIImage?

    init() {
        loadImage()
    }

    func loadImage() {
        if let data = profileImageData {
            profileImage = UIImage(data: data)
        }
    }

    func saveImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.6) {
            profileImageData = data
            profileImage = image
        }
    }

    func handleImageSelection() {
        Task {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.saveImage(uiImage)
                }
            }
        }
    }
}
