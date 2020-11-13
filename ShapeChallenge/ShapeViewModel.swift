//
//  ShapeViewModel.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/13/20.
//

import Foundation
import UIKit

class ShapeViewModel {
    var shapes = [UIView]()
    var removeShapeTimer: Timer?
    var colorClient: ColorClient
    
    init(colorClient: ColorClient = ColorClient()) {
        self.colorClient = colorClient
    }
    
    func createShape(in view: UIView, at position: CGPoint, type: ShapeType, fillType: ShapeFillType) -> UIView {
        let maxSize = min(view.width*0.45, view.height*0.45)
        let minSize = max(view.width*0.1, view.height*0.1)
        
        let size = CGFloat.random(between: maxSize, and: minSize)
        let shape = ShapeView(frame: CGRect(x: position.x - size/2, y: position.y - size/2, width: size, height: size), colorClient: colorClient, type: type, fillType: fillType)
        shapes.append(shape)
        return shape
    }
    
    func handleMotionBegan(_ motion: UIEvent.EventSubtype, handler: @escaping (UIView)->()) {
        if motion == .motionShake, removeShapeTimer == nil || removeShapeTimer?.isValid != true {
            // Remove shape for each 0.1s device shaking
            removeShapeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] (timer) in
                if let shape = self.shapes.popLast() {
                    handler(shape)
                } else {
                    timer.invalidate()
                }
            }
        }
    }
    
    func handleMotionEnd(_ motion: UIEvent.EventSubtype) {
        if motion == .motionShake {
            removeShapeTimer?.invalidate()
            removeShapeTimer = nil
        }
    }
}
