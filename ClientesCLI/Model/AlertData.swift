//
//  AlertData.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 12/7/22.
//

import SwiftUI

struct AlertData {
    let title: String
    let text: String
    let textButton: String?
    
    static let empty = AlertData(title: "", text: "", textButton: nil)
}
