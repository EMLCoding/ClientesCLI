//
//  ClientesCLIApp.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import SwiftUI

@main
struct ClientesCLIApp: App {
    @StateObject var clienteVM = ClienteVM()
    @StateObject var loginVM = LoginVM()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(clienteVM)
                .environmentObject(loginVM)
        }
    }
}
