//
//  SosWarningView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/1/18.
//

import UIKit

class SosWarningView: UIView {

    var radarColor:UIColor = .red
    
    var radarBorderColor:UIColor = .red.withAlphaComponent(0.7)
    
    let viewWidthHeight:CGFloat = 80
    
    lazy var sosLabel:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "SOS"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(sosLabel)
        sosLabel.frame = CGRect(x: (frame.size.width - viewWidthHeight) / 2, y: (frame.size.height - viewWidthHeight) / 2, width: viewWidthHeight, height: viewWidthHeight)
        
        sosLabel.backgroundColor = radarColor
        sosLabel.layer.masksToBounds = true
        sosLabel.layer.cornerRadius = viewWidthHeight / 2
        
        addAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAnimation() {
        let pulsingCount = 3
        let animationDuration:Double = 2
        
        
        let animationLayer = CALayer()
        
        for i in 0 ..< pulsingCount{
            
            let pulsingLayer = CALayer()
            
            let drawWidth = viewWidthHeight
            
            pulsingLayer.frame = CGRect(x: (self.bounds.size.width - drawWidth) / 2, y: (self.bounds.size.height - drawWidth) / 2, width: drawWidth, height: drawWidth)
            pulsingLayer.backgroundColor = self.radarColor.cgColor
            pulsingLayer.borderColor = self.radarBorderColor.cgColor
            pulsingLayer.borderWidth = 1
            pulsingLayer.cornerRadius = drawWidth / 2
            
            let defaultCurve = CAMediaTimingFunction(name: .linear)
            
            let animationGroup = CAAnimationGroup()
            animationGroup.fillMode = .both
            animationGroup.beginTime = CACurrentMediaTime() + Double(i) * animationDuration / Double(pulsingCount)
            animationGroup.duration = animationDuration
            animationGroup.repeatCount = MAXFLOAT
            animationGroup.timingFunction = defaultCurve
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.autoreverses = false
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = 1.5 + Double(i) * 0.5
            
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnimation.values = [1.0,0.5,0.3,0]
            opacityAnimation.keyTimes = [0,0.5,0.75,1]
            
    
            
            animationGroup.animations = [scaleAnimation,opacityAnimation]
            
            pulsingLayer.add(animationGroup, forKey: "pulsing")
            animationLayer.addSublayer(pulsingLayer)
        }
        animationLayer.zPosition = -1
        
        
        
        self.layer.addSublayer(animationLayer)
        
        
    }
    
    
    
    
}
