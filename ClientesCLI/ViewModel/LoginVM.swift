//
//  LoginVM.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 23/7/22.
//

import SwiftUI

final class LoginVM: ObservableObject {
    
    @Published var isLogged = false
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    
    func login() {
        Task {
            do {
                try await ModelNetwork.shared.login(username: "edu", password: "12345678")
            }
            catch {
                print("ERROR LOGIN: \(error)")
            }
        }
    }
}
