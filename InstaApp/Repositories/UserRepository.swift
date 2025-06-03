//
//  UserRepository.swift
//  InstaApp
//
//  Created by Adnan Ali on 03.06.25.
//
import Combine

protocol UserRepositoryProtocol {
    var usersPublisher: AnyPublisher<[User], Never> { get }
    func fetchUsers() async -> [User]
}

final class UserRepository: UserRepositoryProtocol {
    private let dataSource: UserDataSource
    private var currentPageIndex = 0
    private let subject = PassthroughSubject<[User], Never>()
    var usersPublisher: AnyPublisher<[User], Never> {
        subject.eraseToAnyPublisher()
    }
    
    init(dataSource: UserDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchUsers() async -> [User] {
        let users = await dataSource.getUsers(by: currentPageIndex)
        subject.send(users)
        
        currentPageIndex += 1
        return users
    }
    
    func reset() {
        currentPageIndex = 0
    }
}
