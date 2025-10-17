//
//  User.swift
//  Face Book
//
//  Created by Xufeng Zhang on 16/10/25.
//
import Foundation

enum Section: String, CaseIterable, Hashable, Sendable, Codable {
    case main
}

struct UsersPage: Decodable, Sendable {
    let users: [User]
    let total: Int
    let skip: Int
    let limit: Int
}


nonisolated struct User: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: Int
    var firstName: String
    var lastName: String
    var maidenName: String?
    var age: Int
    var email: String
    var phone: String
    var birthday: Date
    var avatarURL: URL?
    var city: String
    var state: String

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, maidenName, age, email, phone
        case birthday = "birthDate"
        case avatarURL = "image"
        case address
    }

    enum AddressCodingKeys: String, CodingKey {
        case city
        case state
    }

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id         = try c.decode(Int.self, forKey: .id)
        firstName  = try c.decode(String.self, forKey: .firstName)
        lastName   = try c.decode(String.self, forKey: .lastName)
        maidenName = try c.decodeIfPresent(String.self, forKey: .maidenName)
        age        = try c.decode(Int.self, forKey: .age)
        email      = try c.decode(String.self, forKey: .email)
        phone      = try c.decode(String.self, forKey: .phone)

        let dateStr = try c.decode(String.self, forKey: .birthday)
        guard let d = Self.dayFormatter.date(from: dateStr) else {
            throw DecodingError.dataCorruptedError(
                forKey: .birthday, in: c, debugDescription: "Expected yyyy-MM-dd"
            )
        }
        birthday = d

        if let s = try c.decodeIfPresent(String.self, forKey: .avatarURL) {
            avatarURL = URL(string: s)
        } else {
            avatarURL = nil
        }

        let addr = try c.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        city  = try addr.decode(String.self, forKey: .city)
        state = try addr.decode(String.self, forKey: .state)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encodeIfPresent(maidenName, forKey: .maidenName)
        try c.encode(age, forKey: .age)
        try c.encode(email, forKey: .email)
        try c.encode(phone, forKey: .phone)
        try c.encode(Self.dayFormatter.string(from: birthday), forKey: .birthday)
        try c.encodeIfPresent(avatarURL?.absoluteString, forKey: .avatarURL)
    }

    var fullName: String {
        if let m = maidenName, !m.isEmpty { return "\(firstName) \(m) \(lastName)" }
        return "\(firstName) \(lastName)"
    }
}

//enum Section: String, CaseIterable, Hashable, Sendable, Codable {
//    case main
//}
//
//struct UsersPage: Decodable, Sendable {
//    let users: [User]
//    let total: Int
//    let skip: Int
//    let limit: Int
//}
