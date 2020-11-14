//
//  CircleViewController.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/13/20.
//

import UIKit

class CircleViewController: UIViewController {
    
    var viewModel = ShapeViewModel(type: .circle)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTap(_ sender: UIButton, forEvent event: UIEvent) {
        guard let touches = event.touches(for: sender),
              let position = touches.first?.location(in: view) else {
            return
        }
        
        let shape = viewModel.createShape(in: view, at: position)
        view.addSubview(shape)
    }

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        viewModel.handleMotionBegan(motion) { [unowned self] (shape) in
            UIView.animate(withDuration: 0.3) {
                shape.transform = shape.transform.translatedBy(x: 0, y: self.view.height+shape.height)
            } completion: { (completed) in
                shape.removeFromSuperview()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        viewModel.handleMotionEnd(motion)
    }
}
