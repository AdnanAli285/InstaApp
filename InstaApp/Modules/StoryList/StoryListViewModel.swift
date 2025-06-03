//
//  StoryListViewModel.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//

import Foundation
import Combine

final class StoryListViewModel: ObservableObject {
    @Published private(set) var stories: [Story] = []
    
    private let repository: UserRepositoryProtocol
    private let storage: StoryStateStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(
        repository: UserRepositoryProtocol,
        storage: StoryStateStorage
    ) {
        self.repository = repository
        self.storage = storage
    }
    
    func onAppear() async {
        await loadMore()
    }
    
    func loadMore() async {
        let users = await repository.fetchUsers()
        await setStories(through: users)
    }
    
    @MainActor
    private func setStories(through users: [User]) {
        let newStories = users.compactMap { user in
            Story(
                id: user.id,
                name: user.name,
                imageURL: user.imageUrl,
                isSeen: storage.isSeen(user.id),
                isLiked: storage.isLiked(user.id)
            )
        }
        stories.append(contentsOf: newStories)
    }
    
    func markStorySeen(_ story: Story) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index].isSeen = true
            storage.setSeen(stories[index].isSeen, for: story.id)
        }
    }
    
    func makeStoryViewModel(for story: Story) -> StoryViewModel? {
        guard let index = stories.firstIndex(where: { $0.id == story.id }) else {
            return nil
        }
        
        return StoryViewModel(
            stories: stories,
            initialIndex: index,
            storage: storage) { [weak self] story in
                if let index = self?.stories.firstIndex(where: { $0.id == story.id }) {
                    self?.stories[index].isLiked = story.isLiked
                }
            }
    }
}
