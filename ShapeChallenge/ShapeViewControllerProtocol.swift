//
//  ShapeViewControllerProtocol.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/17/20.
//

import Foundation
import UIKit

protocol ShapeViewControllerProtocol {
    var viewModel: ShapeControllerViewModel { get set }
    func handleViewTap(_ sender: UIButton, forEvent event: UIEvent)
    func handleMotionBegan(_ motion: UIEvent.EventSubtype)
    func handleMotionEnd(_ motion: UIEvent.EventSubtype)
}

extension ShapeViewControllerProtocol where Self: UIViewController {
    func handleViewTap(_ sender: UIButton, forEvent event: UIEvent) {
        viewModel.handleTap(in: view, button: sender, forEvent: event) { [unowned self] shape in
            self.view.addSubview(shape)
        }
    }
    
    func handleMotionBegan(_ motion: UIEvent.EventSubtype) {
        viewModel.handleMotionBegan(motion) { [unowned self] (shape) in
            UIView.animate(withDuration: 0.3) {
                shape.transform = shape.transform.translatedBy(x: 0, y: self.view.height+shape.height)
            } completion: { (completed) in
                shape.removeFromSuperview()
            }
        }
    }
    
    func handleMotionEnd(_ motion: UIEvent.EventSubtype) {
        viewModel.handleMotionEnd(motion)
    }
}
