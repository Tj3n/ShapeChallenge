//
//  RandomViewController.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/13/20.
//

import UIKit

class RandomViewController: UIViewController, ShapeViewControllerProtocol {
    
    var viewModel = ShapeControllerViewModel(type: .random)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTap(_ sender: UIButton, forEvent event: UIEvent) {
        handleViewTap(sender, forEvent: event)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        handleMotionBegan(motion)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        handleMotionEnd(motion)
    }
}
