//
//  Theme.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//

import SwiftUI

enum Theme {
    static let accent = Color(red: 0.03, green: 0.55, blue: 0.95)
    static let background = Color(red: 0.08, green: 0.08, blue: 0.10)
    static let cardBackground = Color(white: 1.0).opacity(0.06)
    static let titleFont = Font.system(size: 34, weight: .bold, design: .rounded)
    static let headingFont = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 16, weight: .regular, design: .default)
    static let cornerRadiun: CGFloat = 16
    static let spacing: CGFloat = 16
}
