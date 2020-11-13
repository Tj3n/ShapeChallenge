//
//  ColorModel.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/12/20.
//

import Foundation
import UIKit

// MARK: - ColorModel
struct ColorModel: Codable {
    let id: Int
    let title, userName: String
    let numViews, numVotes, numComments, numHearts: Int
    let rank: Int
    let dateCreated, hex: String
    let rgb: RGB
    let hsv: Hsv
    let description: String
    let url: String
    let imageUrl, badgeUrl: String
    let apiUrl: String
    
    var color: UIColor {
        return UIColor(hexString: hex)
    }
}

// MARK: - Hsv
struct Hsv: Codable {
    let hue, saturation, value: Int
}

// MARK: - RGB
struct RGB: Codable {
    let red, green, blue: Int
}
