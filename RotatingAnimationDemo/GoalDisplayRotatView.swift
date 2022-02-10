//
//  GoalDisplayRotatView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2021/11/9.
//

import UIKit

class GoalDisplayRotatView: UIView {

    lazy var frontView:RotatingView = {
        let front = RotatingView(frame: self.bounds, backGroudImage: UIImage(named: "weekly_running_front"), showImage: nil, showText: nil)
        return front
    }()
    
    
    lazy var backView:RotatingView = {
        let back = RotatingView(frame: self.bounds, backGroudImage: UIImage(named: "weekly_running_back"), showImage: nil, showText: nil)
        return back
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(frontView)
        self.addSubview(backView)
        frontView.isHidden = false
        backView.isHidden = true
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewHaveClick))
        self.addGestureRecognizer(tap)
    }
    
    @objc func viewHaveClick() {
        // 执行动画
        
        UIView.transition(with: self, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft) { [self] in
            self.frontView.isHidden = !self.frontView.isHidden
            self.backView.isHidden = !self.backView.isHidden
        } completion: { _ in
            
        }

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
