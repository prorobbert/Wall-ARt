//
//  Wall_AR_t_visionOSApp.swift
//  Wall AR-t visionOS
//
//  Created by Robbert Ruiter on 11/06/2024.
//

import SwiftUI

@main
struct Wall_AR_t_visionOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
