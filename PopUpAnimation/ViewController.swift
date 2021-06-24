//
//  ViewController.swift
//  PopUpAnimation
//
//  Created by Юлия Караневская on 24.06.21.
//


import UIKit

class PopUpAnimationViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    
    let containerView: UIView = {
        
        let containerView = UIView()
        
        let iconHeight: CGFloat = 50
        let iconWidth: CGFloat = 50
        let padding: CGFloat = 8
        
        let arrangedSubviews = [UIColor.red, .green, .blue, .yellow, .purple].map({ color -> UIView in
            let view = UIView()
            view.backgroundColor = color
            view.layer.cornerRadius = iconHeight / 2
            view.isUserInteractionEnabled = true
            return view
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        let iconNumbers = CGFloat(arrangedSubviews.count)
        
        
        containerView.backgroundColor = .white
        containerView.frame = .init(x: 0, y: 0, width: iconWidth * iconNumbers + padding * (iconNumbers + 1), height: iconHeight + padding * 2)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
      
        
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        stackView.frame = containerView.frame
        
        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))

    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        }
        
        if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                let stackView = self.containerView.subviews.first
                stackView?.subviews.forEach({ subView in
                    subView.transform = .identity
                    
                })
            } completion: { _ in
                self.containerView.removeFromSuperview()
            }
        }
        
        if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
        
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self.containerView)
        print(location)
        let hitTestView = containerView.hitTest(location, with: nil)
    
        
        if hitTestView is UIView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
               
                let stackView = self.containerView.subviews.first
                stackView?.subviews.forEach({ subView in
                    subView.transform = .identity
                    
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            }
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        
        view.addSubview(containerView)
        
        let pressedLocation = gesture.location(in: self.view)
        
        let centeredX = (view.frame.width - containerView.frame.width) / 2
        
        containerView.alpha = 0
        
        containerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.containerView.alpha = 1
            self.containerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.containerView.frame.height)
        }
    }
    


}


