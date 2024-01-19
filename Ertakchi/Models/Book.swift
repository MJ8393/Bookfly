//
//  Book.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 06/01/24.
//

import Foundation

struct Book: Codable {
    let id: Int64
    let title: String
    let author: String?
    let videoLink: String?
    let audioLinks: AudioLinks?
    var yourReview: BookReviews?
    let isWritableReview: Bool?
    let overallRank: Double?
    let reviews: [BookReviews]?
    let links: BookLink?
    let imageLink: String?
    let description: String?
    var isFavorite: Bool?
    var isPurchased: Bool?
    let likesCount: Int?
    let releaseDate: String?
    let pageLength: Int?
    let price: Double?
    let genre: BookGenre?
    let latitude: Double?
    let longitude: Double?
    let availableLocation: Bool?
    let availableVideo: Bool?
    let availableEformat: Bool?
}

struct AudioLinks: Codable {
    let uz: String?
    let en: String?
}

struct BookReviews: Codable {
    var message: String?
    let username: String?
    let userPhoto: String?
    var date: String?
    var rank: Int?
}

struct BookLink: Codable {
    let uz: String?
    let en: String?
}

struct BookGenre: Codable {
    let title: String?
    let bookNumbers: Int?
}
