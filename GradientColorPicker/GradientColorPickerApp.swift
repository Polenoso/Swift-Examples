//
//  GradientColorPickerApp.swift
//  GradientColorPicker
//
//  Created by Aitor Pagán on 1/10/24.
//

import SwiftUI

@main
struct GradientColorPickerApp: App {
    @State private var color = Color.red
    var body: some Scene {
        WindowGroup {
            ContentView(selectedColor: $color)
        }
    }
}
