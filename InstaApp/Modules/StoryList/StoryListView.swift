//
//  StoryListView.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//
import SwiftUI

enum Route: Hashable {
    case detail(Story)
}

struct StoryListView: View {
    @ObservedObject var viewModel: StoryListViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.stories, id: \.id) { story in
                        storyView(story)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .navigationTitle("Stories")
            .navigationDestination(for: Route.self) { route in
                if case let .detail(story) = route {
                    if let storyViewModel = viewModel.makeStoryViewModel(for: story) {
                        StoryView(
                            viewModel: storyViewModel
                        )
                    }
                } else {
                    Text("Unable to load story")
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
    
    func storyView(_ story: Story) -> some View {
        return Button {
            path.append(Route.detail(story))
        } label: {
            Circle()
                .strokeBorder(story.isSeen ? Color.gray : Color.blue, lineWidth: 3)
                .background(
                    AsyncImage(
                        url: URL(string: story.imageURL))
                    .frame(width: 84 , height: 84)
                    .clipShape(Circle())
                    .scaledToFit()
                )
                .frame(width: 90, height: 90)
        }
        .buttonStyle(.plain)
        .onAppear {
            if story == viewModel.stories.last {
                Task { @MainActor
                    in await viewModel.loadMore()
                }
            }
        }
    }
}
