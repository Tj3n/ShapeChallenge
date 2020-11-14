//
//  ShapeView.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/12/20.
//

import Foundation
import UIKit
import TVNExtensions

class ShapeView: UIView {
    var viewModel: ShapeViewModel
    private var identity = CGAffineTransform.identity.rotated(by: CGFloat.random(between: 0, and: .pi*2))
    
    init(frame: CGRect, viewModel: ShapeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        switch viewModel.type {
        case .circle:
            cornerRadius = self.height/2
        case .triangle:
            let heightWidth = frame.size.width
            let path = CGMutablePath()
            
            path.move(to: CGPoint(x: 0, y: heightWidth))
            path.addLine(to: CGPoint(x:heightWidth/2, y: 0))
            path.addLine(to: CGPoint(x:heightWidth, y:heightWidth))
            path.addLine(to: CGPoint(x:0, y:heightWidth))
            
            let mask = CAShapeLayer()
            mask.path = path
            mask.frame = bounds
            layer.mask = mask
        default:
            break
        }
        
        //Randomly rotate the view on initial
        transform = identity
    }
    
    func setupGesture() {
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag(_:)))
        dragGesture.delegate = self
        addGestureRecognizer(dragGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(_:)))
        pinchGesture.delegate = self
        addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(onRotation(_:)))
        rotationGesture.delegate = self
        addGestureRecognizer(rotationGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
        makeFill()
    }
    
    func makeFill() {
        let indicator = UIActivityIndicatorView.showInView(self, withBackground: false)
        
        viewModel.getBackgroundColor { [unowned self] (color) in
            indicator.end {
                self.identity = self.transform
                UIView.animate(withDuration: 0.1) {
                    self.transform = .init(scaleX: 0.1, y: 0.1)
                } completion: { (_) in
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                        self.transform = self.identity
                        self.backgroundColor = color
                    }
                }
            }
        }
    }

// MARK: - Gesture handler
    @objc func onDrag(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        if let viewToDrag = gesture.view {
            viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x, y: viewToDrag.center.y + translation.y)
            gesture.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
        }
    }
    
    @objc func onPinch(_ gesture: UIPinchGestureRecognizer) {
        guard let _ = gesture.view else { return }
        switch gesture.state {
        case .began:
            identity = transform
        case .changed,.ended:
            transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    
    @objc func onRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let _ = gesture.view else { return }
        transform = transform.rotated(by: gesture.rotation)
    }
    
    @objc func onDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let _ = gesture.view else { return }
        makeFill()
    }
}

extension ShapeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
