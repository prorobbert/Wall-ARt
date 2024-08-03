//
//  User.swift
//  Domain
//
//  Created by Robbert Ruiter on 01/08/2024.
//

import Foundation
import SwiftData
import CryptoKit

@Model
public class User: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID
    @Attribute(.unique) public var username: String
    @Attribute(.unique) public var email: String
    public var firstName: String
    public var lastName: String
    private var passwordHash: String
    private var salt: String

    public init(
        username: String,
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        let salt = User.generateSalt()
        self.salt = salt
        self.passwordHash = User.hashPassword(password, salt: salt)
    }

    public var name: String {
        return "\(firstName) \(lastName)"
    }

    public func verifyPassword(_ password: String) -> Bool {
        return User.hashPassword(password, salt: self.salt) == self.passwordHash
    }

    private static func generateSalt() -> String {
        let saltData = Data((0..<16).map { _ in UInt8.random(in: 0...255) })
        return saltData.base64EncodedString()
    }

    private static func hashPassword(_ password: String, salt: String) -> String {
        let saltedPassword = password + salt
        let hash = SHA256.hash(data: saltedPassword.data(using: .utf8)!)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

public extension User {
    static var mockedPreview: User {
        let user = User(
            username: "ro-ru",
            email: "ro-ru@live.nl",
            password: "Welkom123!",
            firstName: "Robbert",
            lastName: "Ruiter"
        )
        return user
    }
}

public extension Array where Element == User {
    static var mockedPreview: Self {
        return [
            User(
                username: "johndoe",
                email: "johndoe@test.com",
                password: "Welkom123!",
                firstName: "John",
                lastName: "Doe"
            ),
            User(
                username: "janedoe",
                email: "janedoe@test.com",
                password: "Welkom123!",
                firstName: "Jane",
                lastName: "Doe"
            )
        ]
    }
}
