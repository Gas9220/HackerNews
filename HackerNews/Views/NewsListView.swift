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
                ForEach(vm.stories, id: \.self) { story in
                    NavigationLink(value: story) {
                        StoryRowView(story: story)
                    }
                }

                if !vm.isFinished {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.black)
                        .foregroundColor(.red)
                        .onAppear {
                            vm.task = Task {
                                if !vm.storiesIds.isEmpty {
                                    await vm.fetchStories()
                                }
                            }
                        }
                }
            }
            .navigationTitle("Hacker News")
            .navigationDestination(for: Story.self) { story in
                StoryDetailView(story: story)
            }
            .refreshable {
                vm.task?.cancel()
                vm.task = Task {
                    await vm.fetchStories()
                }
            }
            .onChange(of: vm.endPoint) { oldValue, newValue in
                vm.task = Task {
                    await vm.switchStoriesList(from: oldValue, to: newValue)
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
