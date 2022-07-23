//
//  LoginView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 23/7/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginVM: LoginVM
    var body: some View {
        Form {
            TextField("Username", text: $loginVM.username)
            SecureField("Password", text: $loginVM.password)
            Button("Iniciar sesión") {
                loginVM.login()
            }
        }
        .navigationTitle("Iniciar sesión")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
