//
//  NewsListView.swift
//  HackerNews
//
//  Created by Gaspare Monte on 19/03/24.
//

import SwiftUI

struct NewsListView: View {
    @StateObject var vm: ViewModel = ViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.stories.sorted(), id: \.self) { story in
                    NavigationLink(value: story) {
                        Text(story.by)
                    }
                }
            }
            .navigationTitle("Hacker News")
            .refreshable {
                vm.task?.cancel()
                vm.task = Task {
                    await vm.fetchStories()
                }
            }
            .onChange(of: vm.endPoint) {
                vm.stories = []
                vm.task?.cancel()
                vm.task = Task {
                    await vm.fetchStories()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("News Count: \(vm.stories.count)")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("selection", selection: $vm.endPoint) {
                            ForEach(Endpoint.allCases, id: \.self) { endpoint in
                                Text(endpoint.description)
                                    .tag(endpoint)
                            }
                        }
                    } label: {
                        Label("News type", systemImage: "list.bullet")
                    }
                }
            }
        }
    }
}

#Preview {
    NewsListView()
}
