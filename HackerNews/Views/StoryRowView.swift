//
//  StoryRowView.swift
//  HackerNewsShadow
//
//  Created by Gaspare Monte on 20/03/24.
//

import SwiftUI

struct StoryRowView: View {
    let story: Story

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Author: \(story.by.capitalized)")

                Spacer()

                Text(story.type)
                    .padding(.vertical ,5)
                    .padding(.horizontal , 10)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text(story.title)

            Text(story.date.formatted(date: .complete, time: .omitted))
        }
    }
}

#Preview {
    List {
        StoryRowView(story: Story.example)
    }
}
