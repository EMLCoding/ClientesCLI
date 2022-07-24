//
//  LoginVM.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 23/7/22.
//

import SwiftUI

final class LoginVM: ObservableObject {
    
    @Published var userLogged: UserLoggedJWT?
    @Published var isLogged = false
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    init() {
        // El token expira cada X tiempo, por lo que habria que ir comprobando si no ha expirado ya.
        if isTokenExpirado() {
            isLogged = false
            userLogged = nil
        }
    }
    
    @MainActor
    func login() {
        Task {
            do {
                try await ModelNetwork.shared.login(username: username, password: password)
                if let token = SecKeyStore.shared.readKey(label: "JWTTOKEN") {
                    guard let tokenString = String(data: token, encoding: .utf8) else {
                        throw APIErrors.process
                    }
                    userLogged = decodeJWT(jwtToken: tokenString)
                    if let _ = userLogged {
                        isLogged = true
                    } else {
                        isLogged = false
                    }
                } else {
                    print("No se ha logueado correctamente")
                }
            }
            catch {
                print("ERROR LOGIN: \(error)")
            }
        }
    }
    
    func isTokenExpirado() -> Bool {
        do {
            if let token = SecKeyStore.shared.readKey(label: "JWTTOKEN") {
                guard let tokenString = String(data: token, encoding: .utf8) else {
                    throw APIErrors.process
                }
                if let userDataToken = decodeJWT(jwtToken: tokenString) {
                    let now = Date.now.timeIntervalSince1970
                    print("date actual: \(now)")
                    if (userDataToken.exp > now.hashValue) {
                        return false
                    }
                } else {
                    return true
                }
            } else {
                throw APIErrors.process
            }
        } catch {
            return true
        }
        return true
    }
}
