//
//  CellFunApp.swift
//  CellFun
//
//  Created by Spencer Symington on 2024-04-27.
//

import SwiftUI

@main
struct CellFunApp: App {
    let appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}
