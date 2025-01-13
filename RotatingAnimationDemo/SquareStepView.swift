//
//  SquareStepView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/1/3.
//

import UIKit

class SquareStepView: TricolorStepView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func drawCycleView() {
        let cyclePadding:CGFloat = cycleWidth * 2
        let viewWidth = self.frame.size.width
        let viewHeight = self.frame.size.height
        let radius = viewWidth / 2  - cycleWidth / 2 - cyclePadding
        
        let centerPoint = CGPoint(x: viewWidth / 2, y: viewHeight / 2)
        
        // 步数
        
        let stepCircle =  UIBezierPath(arcCenter: centerPoint, radius: radius , startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        drawCycleLayer(strokeColor: stepDrawBackColor,cycleCircle: stepCircle)
        
        stepLayer.frame = self.bounds
        stepLayer.fillColor = UIColor.clear.cgColor
        stepLayer.lineWidth = cycleWidth
        stepLayer.lineCap = .round
        stepLayer.strokeColor = stepColor.cgColor
        stepLayer.strokeStart = 0
        stepLayer.strokeEnd = stepProgress
        stepLayer.path = stepCircle.cgPath
        self.layer.addSublayer(stepLayer)
        
        // 距离
        let anglePadding:CGFloat = .pi / 24
        let distanceCircle = UIBezierPath(arcCenter: centerPoint, radius: radius +  cyclePadding, startAngle: .pi + anglePadding , endAngle: 2 * .pi - anglePadding , clockwise: true)
        drawCycleLayer(strokeColor: distanceDrawBackColor,cycleCircle: distanceCircle)
        
        distanceLayer.frame = self.bounds
        distanceLayer.fillColor = UIColor.clear.cgColor
        distanceLayer.lineWidth = cycleWidth
        distanceLayer.lineCap = .round
        distanceLayer.strokeColor = distanceColor.cgColor
        distanceLayer.strokeStart = 0
        distanceLayer.strokeEnd = distanceProgress
        distanceLayer.path = distanceCircle.cgPath
        self.layer.addSublayer(distanceLayer)
        
        
        // 卡路里
        let caloriesCircle = UIBezierPath(arcCenter: centerPoint, radius: radius +  cyclePadding , startAngle: .pi - anglePadding, endAngle: anglePadding, clockwise: false)
        drawCycleLayer(strokeColor: caloriesDrawBackColor, cycleCircle: caloriesCircle)
        caloriesLayer.frame = self.bounds
        caloriesLayer.fillColor = UIColor.clear.cgColor
        caloriesLayer.lineWidth = cycleWidth
        caloriesLayer.lineCap = .round
        caloriesLayer.strokeColor = caloriesColor.cgColor
        caloriesLayer.strokeStart = 0
        caloriesLayer.strokeEnd = caloriesProgress
        caloriesLayer.path = caloriesCircle.cgPath
        self.layer.addSublayer(caloriesLayer)
        
        
    }

}
