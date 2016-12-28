//
//  GravityAnimation.swift
//  PresentrExample
//
//  Created by Francesco Perrotti-Garcia on 12/28/16.
//  Copyright © 2016 Presentr. All rights reserved.
//

import Presentr

class GravityAnimation: PresentrAnimation {
    
    var animator: UIDynamicAnimator?
    
    override func customAnimation(using transitionContext: UIViewControllerContextTransitioning) -> Bool {
        return true
    }
    
    override var animationDuration: TimeInterval {
        return 0.5
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        let isPresenting: Bool = (toViewController?.presentingViewController == fromViewController)
        
        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        let initialFrameForVC = transform(containerFrame: containerView.frame, finalFrame: finalFrameForVC)
        
        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
        
        let duration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        animatingView?.frame = initialFrame
        
        
        let animator = UIDynamicAnimator(referenceView: containerView)
        let gravity = UIGravityBehavior(items: [animatingView!])
        
        let finalX = containerView.bounds.height
        
        let deltaX = (finalX - initialFrame.minX) + initialFrame.height
        
        let durationSquared = CGFloat(duration * duration)
        
        let acceleration = (2 * deltaX) / durationSquared
        
        gravity.magnitude = acceleration / 1000
        
        animator.addBehavior(gravity)
        self.animator = animator
        
        UIView.animate(withDuration: duration, animations: {
            animatingView?.alpha = 0
        }, completion: { _ in
            if !isPresenting {
                fromView?.removeFromSuperview()
            }

            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)

            animatingView?.alpha = 1
        })
        
    }
    
}
