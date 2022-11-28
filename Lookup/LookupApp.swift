//
//  LookupApp.swift
//  Lookup
//
//  Created by Adrian Bolinger on 11/27/22.
//

import SwiftUI

// https://developer.apple.com/documentation/SwiftUI/MenuBarExtra

@main
struct LookupApp: App {
    var body: some Scene {
        let viewModel = LookupViewModel()

        MenuBarExtra("", systemImage: "text.book.closed") {
            LookupView(viewModel: viewModel)
        }
        .menuBarExtraStyle(.window)
    }
}
