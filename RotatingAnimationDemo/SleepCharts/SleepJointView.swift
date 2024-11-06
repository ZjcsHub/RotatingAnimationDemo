//
//  SleepJointView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/8/31.
//

import UIKit

enum SleepJointType {
    case leftTop
    case leftBottom
}
class SleepJointLayer:CALayer {
    
  
    convenience init(frame:CGRect,backGroundColorList:[CGColor],jointWidth:CGFloat,jointHeight:CGFloat,radius:CGFloat,jointType:SleepJointType) {
        self.init()
        self.frame = frame
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = backGroundColorList
        gradientLayer.locations = [0, 1]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
       
        self.addSublayer(gradientLayer)
         
        let middleWidth = frame.size.width / 2
        // 中间线区间
        let spaceHeight:CGFloat = jointHeight
        let spaceWidth:CGFloat = jointWidth
        let itemHeight = (bounds.size.height - spaceHeight) / 2
        let itemWidth =  middleWidth + spaceWidth / 2
      
        
        let bezierPath = UIBezierPath()
        if jointType == .leftTop {
            bezierPath.move(to: CGPoint.zero)
            var startPoint = CGPoint(x: itemWidth - radius, y: 0)
            var endPoint = CGPoint(x:itemWidth, y: radius)
            bezierPath.addLine(to: startPoint)
            
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x, y: endPoint.y), radius: radius, startAngle: Double.pi / 2 * 3, endAngle: Double.pi * 2, clockwise: true)
            
            
            startPoint = CGPoint(x: endPoint.x, y: itemHeight + spaceHeight - radius)
            endPoint = CGPoint(x: startPoint.x + radius, y: startPoint.y + radius)
            
            bezierPath.addLine(to: startPoint)
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x, y: startPoint.y), radius: radius, startAngle: Double.pi, endAngle: Double.pi / 2, clockwise: false)
            
            bezierPath.addLine(to: CGPoint(x: self.bounds.size.width, y: endPoint.y))
            
            bezierPath.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
            
            startPoint = CGPoint(x: self.bounds.size.width - itemWidth + radius, y: self.bounds.size.height)
            
            endPoint = CGPoint(x: startPoint.x - radius, y: startPoint.y - radius)
            
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x, y: endPoint.y), radius: radius, startAngle: Double.pi / 2, endAngle: Double.pi, clockwise: true)
            
            startPoint = CGPoint(x: endPoint.x, y: itemHeight + radius)
            endPoint = CGPoint(x: startPoint.x - radius, y: startPoint.y - radius)
            
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x, y: startPoint.y), radius: radius, startAngle: Double.pi * 2, endAngle: Double.pi * 3 / 2, clockwise: false)
            
            bezierPath.addLine(to: CGPoint(x: 0, y: itemHeight))
            
          
        }else{
            bezierPath.move(to: CGPoint(x: 0, y: self.bounds.size.height))
            
            var startPoint = CGPoint(x: itemWidth - radius, y: self.bounds.size.height)
            var endPoint = CGPoint(x: startPoint.x + radius, y: startPoint.y - radius)
            bezierPath.addLine(to: startPoint)
            
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x, y: endPoint.y), radius: radius, startAngle: Double.pi / 2, endAngle: 0, clockwise: false)
            
            startPoint = CGPoint(x: endPoint.x , y: itemHeight + radius)
            endPoint = CGPoint(x: startPoint.x + radius, y: startPoint.y - radius)
            bezierPath.addLine(to: startPoint)
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x, y: startPoint.y), radius: radius, startAngle: Double.pi, endAngle: Double.pi * 3 / 2, clockwise: true)
            
            bezierPath.addLine(to: CGPoint(x: self.bounds.size.width, y: endPoint.y))
            
            bezierPath.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
            
            startPoint = CGPoint(x: self.bounds.size.width - itemWidth + radius, y: 0)
            
            endPoint = CGPoint(x: startPoint.x - radius, y: startPoint.y + radius)
            
            bezierPath.addLine(to: startPoint)
            
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x, y: endPoint.y), radius: radius, startAngle: Double.pi * 3 / 2, endAngle: Double.pi, clockwise: false)
            startPoint = CGPoint(x: endPoint.x, y: self.bounds.size.height - itemHeight - radius)
            endPoint = CGPoint(x: startPoint.x - radius, y: startPoint.y + radius)
            bezierPath.addLine(to: startPoint)
            bezierPath.addArc(withCenter:  CGPoint(x: endPoint.x, y: startPoint.y), radius: radius, startAngle: 0, endAngle: Double.pi / 2, clockwise: true)

            bezierPath.addLine(to: CGPoint(x: 0, y: endPoint.y))
            
            bezierPath.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
            
        }
       
        bezierPath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
    
        gradientLayer.mask = shapeLayer
       
    }
    
    
    
    
}
