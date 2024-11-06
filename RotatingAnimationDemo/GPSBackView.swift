//
//  GPSBackView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/9/14.
//

import UIKit

class GPSBackView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.orange.cgColor,UIColor.clear.cgColor]
        gradientLayer.locations = [0, 1]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
       
        self.layer.addSublayer(gradientLayer)
         
        let width = self.bounds.size.width
        
        let x = width - cos(width/2)
        
        let y = width + cos(width/2)
        
        let bezierPath = UIBezierPath()
//        bezierPath.move(to: CGPoint(x: x, y: y))
        bezierPath.addArc(withCenter: CGPoint(x: width/2, y: width/2), radius: width/2, startAngle:  Double.pi / 4, endAngle:Double.pi * 3 / 4, clockwise: false)
        bezierPath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
    
        gradientLayer.mask = shapeLayer
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
