//
//  StoryViewModel.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//

import Foundation

final class StoryViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published private(set) var stories: [Story]

    private let stateStorage: StoryStateStorage
    private let updateCallback: (Story) -> Void

    init(
        stories: [Story],
        initialIndex: Int,
        storage: StoryStateStorage,
        onUpdate: @escaping (Story) -> Void
    ) {
        self.stories = stories
        self.currentIndex = initialIndex
        self.stateStorage = storage
        self.updateCallback = onUpdate
    }

    var currentStory: Story {
        stories[currentIndex]
    }

    func toggleLike() {
        stories[currentIndex].isLiked.toggle()
        stateStorage.setLiked(stories[currentIndex].isLiked, for: stories[currentIndex].id)
        updateCallback(stories[currentIndex])
    }

    func markSeen() {
        stories[currentIndex].isSeen = true
        stateStorage.setSeen(true, for: stories[currentIndex].id)
    }

    func goToNextStory() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            markSeen()
        }
    }

    func goToPreviousStory() {
        if currentIndex > 0 {
            currentIndex -= 1
            markSeen()
        }
    }
}
