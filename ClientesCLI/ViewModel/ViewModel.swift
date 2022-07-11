//
//  ViewModel.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import SwiftUI

final class ViewModel: ObservableObject {
    
    @Published var clientes: [Cliente] = []
    
    @MainActor
    func getClientes() async {
        do {
            clientes = try await ModelNetwork.shared.getClientes()
        } catch {
            print("\(error)")
        }
    }
}
