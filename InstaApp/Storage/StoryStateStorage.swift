//
//  StoryStorage.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//
import Foundation

/*
 I have kept `seen` and `liked` status saperately for the simplicity and improved speed, avoiding storing json after encoding and decoding for getting the value.
 */

struct StoryStateStorage {
    let userDefaults = UserDefaults.standard
    
    func isSeen(_ id: Int) -> Bool {
        userDefaults.bool(forKey: getSeenKey(id))
    }
    
    func isLiked(_ id: Int) -> Bool {
        userDefaults.bool(forKey: getLikedKey(id))
    }
    
    func setSeen(_ seen: Bool, for id: Int) {
        userDefaults.setValue(seen, forKey: getSeenKey(id))
    }
    
    func setLiked(_ liked: Bool, for id: Int) {
        userDefaults.setValue(liked, forKey: getLikedKey(id))
    }
}

private extension StoryStateStorage {
    func getLikedKey(_ id: Int) -> String { "\(id).liked" }
    func getSeenKey(_ id: Int) -> String { "\(id).seen" }
}
