//
//  ContentView.swift
//  HackerNews
//
//  Created by Gaspare Monte on 21/03/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsListView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
