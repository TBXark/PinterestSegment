//
//  DemoData.swift
//  PinterestSegmentDemo
//

import Foundation

/// Data shared by the UIKit and SwiftUI demo tabs so both showcase the
/// same content.
enum DemoData {

    static let titles = [
        "Everything",
        "Geek",
        "Humor",
        "Art",
        "Food",
        "Home",
        "DIY",
        "Women's Style",
        "Man's Style",
        "Beauty",
        "Travel",
    ]

    static let iconSymbolNames = [
        "face.smiling",
        "sun.max",
        "cloud",
        "moon",
        "heart",
        "star",
        "leaf",
    ]

    static var iconTitles: [String] {
        (1...iconSymbolNames.count).map { "Face-\($0)" }
    }
}
