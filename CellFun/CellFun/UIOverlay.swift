//
//  UIOverlay.swift
//  CellFun
//
//  Created by Spencer Symington on 2024-04-28.
//

import SwiftUI

struct UIOverlay: View {
    @EnvironmentObject var appState: AppState
    @State var showMenu = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                
                Circle()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        showMenu.toggle()
                    }
                Toggle("", isOn: $appState.isRunning)
            }
            
            
        }
        .padding(100)
        .sheet(isPresented: $showMenu) {
            // Content of the modal view
            MenuView()
        }
    }
}

#Preview {
    UIOverlay()
}
