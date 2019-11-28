//
//  CustomPresentationController.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

class CustomPresentationController : UIPresentationController {
    
    ///
    public weak var drawerDelegate: DrawerPresentationControllerDelegate?
    
    
    ///
    private var currentSnapPoint: DraweSnapPoint = .middle
    
    
    ///Set radius view controller
    ///Defaults CGFloat: 20
    public var cornerRadius: CGFloat = 20
    
    /// Set the modal's corners that should be rounded.
    /// Defaults are the two top corners.
    public var roundedCorners: UIRectCorner = [.topLeft, .topRight]
    
    
    public var blurEffectStyle: UIBlurEffect.Style = .dark
    
    
    public var positionY : CGFloat = 50
    
    ///blurEffectView
    private lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
        blur.isUserInteractionEnabled = true
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.addGestureRecognizer(self.tapGestureRecognizer)
        return blur
    }()
    
    ///Tap Gesture Dismiss
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
    }()
    
    ///Dismiss
    @objc func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    //pan
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.drag(_:)))
        return pan
    }()
    
    override public var frameOfPresentedViewInContainerView: CGRect {
        print(self.containerView!.frame.height - positionY)
        return CGRect(origin: CGPoint(x: 0, y: positionY), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height - positionY))
    }
    
    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let presentedView = self.presentedView else { return }
        
        presentedView.layer.masksToBounds = true
        presentedView.roundCorners(corners: self.roundedCorners, radius: self.cornerRadius)
        presentedView.addGestureRecognizer(self.panGesture)
    }
    
    @objc func drag(_ gesture:UIPanGestureRecognizer) {
        return
        guard let presentedView = self.presentedView else { return }
        switch gesture.state {
        case .changed:
            self.presentingViewController.view.bringSubviewToFront(presentedView)
            let translation = gesture.translation(in: self.presentingViewController.view)
            let y = presentedView.center.y + translation.y
            print("y: \(y)")
            let preventBounce: Bool = (y - (self.positionY / 2) > self.presentingViewController.view.center.y)
            // If bounce enabled or view went over the maximum y postion.
            if preventBounce {
                presentedView.center = CGPoint(x: self.presentedView!.center.x, y: y)
            }
//            self.positionY = y
            gesture.setTranslation(CGPoint.zero, in: self.presentingViewController.view)
        case .ended:
            let height = self.presentingViewController.view.frame.height
            let position = presentedView.convert(self.presentingViewController.view.frame, to: nil).origin.y
            if position < height/2 {
                self.sendToTop()
            }
//            if position < 0 || position < (1/4 * height) {
//                // TOP SNAP POINT
//                self.sendToTop()
//                self.currentSnapPoint = .top
//            } else if (position < (height / 2)) || (position > (height / 2) && position < (height / 3)) {
//                // MIDDLE SNAP POINT
//                self.sendToTop()
//                self.currentSnapPoint = .middle
//            } else {
//                // BOTTOM SNAP POINT
//                self.currentSnapPoint = .close
//                self.dismiss()
//            }
            if let d = self.drawerDelegate {
                d.drawerMovedTo(position: self.currentSnapPoint)
            }
            print("position: \(position) - height: \(height) - height/4: \(height/4) - height/2: \(height/2)")
            self.positionY = position
            gesture.setTranslation(CGPoint.zero, in: self.presentingViewController.view)
        default:
            return
        }
    }
    
    func sendToTop() {
        guard let presentedView = self.presentedView else { return }
        let topYPosition: CGFloat = (self.presentingViewController.view.center.y + CGFloat(self.positionY / 2))
        print("topYPosition: \(topYPosition)")
        UIView.animate(withDuration: 0.25) {
            presentedView.center = CGPoint(x: presentedView.center.x, y: topYPosition)
            print("sendToTop \(presentedView.center)")
        }
    }
    
    func sendToMiddle() {
        if let presentedView = self.presentedView {
            let y = self.presentingViewController.view.center.y * 2
            UIView.animate(withDuration: 0.25) {
                presentedView.center = CGPoint(x: presentedView.center.x, y: y)
                print("sendToMiddle \(presentedView.center)")
            }
        }
    }
    
    
    override public func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let presenterView = self.containerView else { return }
        guard let presentedView = self.presentedView else { return }
        
        // Set the frame and position of the modal
        presentedView.frame = self.frameOfPresentedViewInContainerView
//        presentedView.frame.origin.x = (presenterView.frame.width - presentedView.frame.width) / 2
//        presentedView.center = CGPoint(x: presentedView.center.x, y: presenterView.center.y * 2)
        
        // Set the blur effect frame, behind the modal
        self.blurEffectView.frame = presenterView.bounds
    }
    
    override public func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override public func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        // Add the blur effect view
        guard let presenterView = self.containerView else { return }
        presenterView.addSubview(self.blurEffectView)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1.0//change alpha blur background
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }

}

private extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


public protocol DrawerPresentationControllerDelegate: class {
    func drawerMovedTo(position: DraweSnapPoint)
}

public enum DraweSnapPoint {
    case top
    case middle
    case close
}
