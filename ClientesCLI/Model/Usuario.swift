//
//  Usuario.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 23/7/22.
//

import SwiftUI

struct Usuario: Identifiable {
    let id: Int
    let username: String
    let password: String
    let nombre: String
    let apellido: String
    let email: String
    let roles: [String]
}

struct LoginParams: Encodable {
    let grant_type: String
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let expiresIn: Int
    let scope: String
    let infoAdicional: String
    let nombreUsuario: String
    let jti: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case infoAdicional = "info_adicional"
        case nombreUsuario = "nombre_usuario"
        case scope, jti
    }
}

struct UserLoggedJWT: Codable {
    let infoAdicional: String
    let userName: String
    let scope: [String]
    let exp: Int
    let nombreUsuario: String
    let roles: [String]
    let jti: String
    let clientId: String
    
    enum CodingKeys: String, CodingKey {
        case infoAdicional = "info_adicional"
        case userName = "user_name"
        case nombreUsuario = "nombre_usuario"
        case clientId = "client_id"
        case roles = "authorities"
        case scope, exp, jti
    }
}
