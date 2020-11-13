//
//  RandomViewController.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/13/20.
//

import UIKit

class RandomViewController: UIViewController {
    
    var viewModel = ShapeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTap(_ sender: UIButton, forEvent event: UIEvent) {
        guard let touches = event.touches(for: sender),
              let position = touches.first?.location(in: view) else {
            return
        }
        
        let types: [(ShapeType, ShapeFillType)] = [(ShapeType.square, ShapeFillType.color), (ShapeType.triangle, ShapeFillType.random), (ShapeType.circle, ShapeFillType.pattern)]
        if let randomType = types.randomElement() {
            let shape = viewModel.createShape(in: view, at: position, type: randomType.0, fillType: randomType.1)
            view.addSubview(shape)
        }
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
