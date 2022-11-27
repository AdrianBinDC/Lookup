//
//  LookupApp.swift
//  Lookup
//
//  Created by Adrian Bolinger on 11/27/22.
//

import SwiftUI

@main
struct LookupApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        MenuBarExtra("MenuBarExtra") {
            Text("MenuBarExtra Content")
        }
    }
}
