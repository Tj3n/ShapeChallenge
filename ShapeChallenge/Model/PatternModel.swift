//
//  PatternModel.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/12/20.
//

import Foundation

// MARK: - PatternModel
struct PatternModel: Codable {
    let id: Int
    let title, userName: String
    let numViews, numVotes, numComments, numHearts: Int
    let rank: Int
    let dateCreated: String
    let colors: [String]
    let description: String
    let url: String
    let imageUrl, badgeUrl: String
    let apiUrl: String
    let template: Template?
}

// MARK: - Template
struct Template: Codable {
    let title: String
    let url: String
    let author: Author
}

// MARK: - Author
struct Author: Codable {
    let userName: String
    let url: String
}
