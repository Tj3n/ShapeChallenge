//
//  ShapeControllerViewModel.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/13/20.
//

import Foundation
import UIKit

enum ShapeType {
    case square, triangle, circle, random
    
    var fillType: ShapeFillType {
        switch self {
        case .circle:
            return .pattern
        case .square:
            return .color
        default:
            return .random
        }
    }
}

enum ShapeFillType {
    case color, pattern, random
}

class ShapeControllerViewModel {
    var shapes = [UIView]()
    var removeShapeTimer: Timer?
    var colorClient: ColorClient
    var type: ShapeType
    
    init(colorClient: ColorClient = ColorClient(), type: ShapeType) {
        self.colorClient = colorClient
        self.type = type
    }
    
    func handleTap(in view: UIView, button: UIButton, forEvent event: UIEvent, addingViewHandler: (UIView) -> ()) {
        guard let touches = event.touches(for: button),
              let position = touches.first?.location(in: view) else {
            return
        }
        handleTap(in: view, at: position, addingViewHandler: addingViewHandler)
    }
    
    func handleTap(in view: UIView, at position: CGPoint, addingViewHandler: (UIView) -> ()) {
        let maxSize = min(view.width*0.45, view.height*0.45)
        let minSize = max(view.width*0.1, view.height*0.1)
        
        let size = CGFloat.random(between: maxSize, and: minSize)
        let frame = CGRect(x: position.x - size/2, y: position.y - size/2, width: size, height: size)
        
        var viewModel: ShapeViewModel
        if type == .random, let randomType = [ShapeType.square,
                                              ShapeType.circle,
                                              ShapeType.triangle].randomElement() {
            // Generate exact type from random ShapeType
            viewModel = ShapeViewModel(colorClient: colorClient, type: randomType)
        } else {
            viewModel = ShapeViewModel(colorClient: colorClient, type: type)
        }
        let shape = ShapeView(frame: frame, viewModel: viewModel)
        shapes.append(shape)
        addingViewHandler(shape)
    }
    
    func handleMotionBegan(_ motion: UIEvent.EventSubtype, removeShapeHandler: @escaping (UIView)->()) {
        if motion == .motionShake, removeShapeTimer == nil || removeShapeTimer?.isValid != true {
            // Remove 1 shape for each 0.1s device shaking
            removeShapeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] (timer) in
                if let shape = self.shapes.popLast() {
                    removeShapeHandler(shape)
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
