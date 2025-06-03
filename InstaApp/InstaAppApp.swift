//
//  InstaAppApp.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//

import SwiftUI

@main
struct InstaAppApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = StoryListViewModel(
                repository: UserRepository(
                    dataSource: UserLocalDataSource()
                ),
                storage: StoryStateStorage()
            )
            StoryListView(viewModel: viewModel)
        }
    }
}
