//
//  Extensions.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import Foundation

extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension Notification.Name {
    static let showAlert = Notification.Name("showAlert")
    static let hideAlert = Notification.Name("hideAlert")
}
