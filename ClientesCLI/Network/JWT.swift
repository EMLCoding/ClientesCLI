//
//  JWT.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 23/7/22.
//

import Foundation

func decodeJWT(jwtToken jwt: String) -> UserLoggedJWT? {
  let segments = jwt.components(separatedBy: ".")
  return decodeJWTPart(segments[1])
}

func base64UrlDecode(_ value: String) -> Data? {
  var base64 = value
    .replacingOccurrences(of: "-", with: "+")
    .replacingOccurrences(of: "_", with: "/")

  let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
  let requiredLength = 4 * ceil(length / 4.0)
  let paddingLength = requiredLength - length
  if paddingLength > 0 {
    let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
    base64 = base64 + padding
  }
  return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
}

func decodeJWTPart(_ value: String) -> UserLoggedJWT? {
    guard let data = base64UrlDecode(value) else {
        return nil
    }
    
    let decoder = getDecoder()
    
    do {
        return try decoder.decode(UserLoggedJWT.self, from: data)
    } catch {
        return nil
    }
}
