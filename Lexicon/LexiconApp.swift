//
//  LexiconApp.swift
//  Lexicon
//
//  Created by Jade Allen Cook on 8/12/25.
//

import SwiftUI
import SwiftData

@main
struct LexiconApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Category.self)
    }
}
