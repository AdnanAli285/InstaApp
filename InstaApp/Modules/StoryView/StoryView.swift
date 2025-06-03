//
//  StoryView.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//
import SwiftUI

struct StoryView: View {
    @ObservedObject private var viewModel: StoryViewModel
    
    init(viewModel: StoryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            AsyncImage(url: URL(string: viewModel.currentStory.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } placeholder: {
                ProgressView()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.toggleLike()
                    }) {
                        Image(systemName: viewModel.currentStory.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.system(size: 30))
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        viewModel.goToNextStory()
                    } else if value.translation.width > 50 {
                        viewModel.goToPreviousStory()
                    }
                }
        )
        .background(Color(.systemBackground))
        .animation(.easeInOut, value: viewModel.currentIndex)
        .onAppear {
            viewModel.markSeen()
        }
    }
}
