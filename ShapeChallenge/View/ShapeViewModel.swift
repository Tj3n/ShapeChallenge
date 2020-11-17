//
//  ShapeViewModel.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/17/20.
//

import Foundation
import UIKit

class ShapeViewModel {
    var colorClient: ColorClient
    var type: ShapeType
    
    init(colorClient: ColorClient = ColorClient(), type: ShapeType) {
        self.colorClient = colorClient
        self.type = type
    }
    
// MARK: - API Background Color
    func getBackgroundColor(_ completion: @escaping (UIColor)->()) {
        switch type.fillType {
        case .color:
            getColor(completion)
        case .pattern:
            getPattern(completion)
        case .random:
            if let randomFunc = [getColor, getPattern].randomElement() {
                randomFunc(completion)
            }
        }
    }
    
    func getColor(_ completion: @escaping (UIColor)->()) {
        colorClient.getRandomColor { (color) in
            completion(color)
        }
    }
    
    func getPattern(_ completion: @escaping (UIColor)->()) {
        colorClient.getRandomPatternColor { (color) in
            completion(color)
        }
    }
}
