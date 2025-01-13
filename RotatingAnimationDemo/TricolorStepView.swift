//
//  TricolorStepView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/12/30.
//

import UIKit

class TricolorStepView: UIView {
    /// 线宽
    internal var cycleWidth:CGFloat = 10
    
    private let angle = 45.0 / 90.0 * (.pi / 2)
    
    internal var stepLayer:CAShapeLayer = CAShapeLayer()
    internal var stepDrawBackColor:UIColor = UIColor.lightGray
    internal var stepColor:UIColor = .red
    
    var stepProgress:Double = 0 {
        didSet {
            stepLayer.strokeEnd = stepProgress
        }
    }

    
    
    
    
    internal var distanceLayer:CAShapeLayer = CAShapeLayer()
    internal var distanceDrawBackColor:UIColor = UIColor.lightGray
    internal var distanceColor:UIColor = .red
    var distanceProgress:Double = 0 {
        didSet {
            distanceLayer.strokeEnd = distanceProgress
        }
    }
    
    internal var caloriesLayer:CAShapeLayer = CAShapeLayer()
    internal var caloriesDrawBackColor:UIColor = UIColor.lightGray
    internal var caloriesColor:UIColor = .red
    var caloriesProgress:Double = 0 {
        didSet {
            caloriesLayer.strokeEnd = caloriesProgress
        }
    }
    
    
    convenience init(frame: CGRect,stepBackColor:UIColor,stepDrawColor:UIColor,distanceBackColor:UIColor,distanceDrawColor:UIColor,caloriesBackColor:UIColor,caloriesDrawColor:UIColor,lineWidth:CGFloat) {
        self.init(frame: frame)
        self.stepDrawBackColor = stepBackColor
        self.stepColor = stepDrawColor
        self.distanceDrawBackColor = distanceBackColor
        self.distanceColor = distanceDrawColor
        self.caloriesDrawBackColor = caloriesBackColor
        self.caloriesColor = caloriesDrawColor
        self.cycleWidth = lineWidth
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.forEach({ (sublayers) in
            sublayers.removeFromSuperlayer()
        })
        drawCycleView()
    }
    
    func getViewMaxWidth(viewHeight:CGFloat) -> CGFloat {
        
        let radius = viewHeight / 2  - cycleWidth / 2
        
        return radius / cos(angle) +  cycleWidth / 2
    }
    
    func drawCycleView() {
        let viewWidth = self.frame.size.width
        let viewHeight = self.frame.size.height
        let radius = viewHeight / 2  - cycleWidth / 2
        
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
       
        let distanceCircle = UIBezierPath(arcCenter: centerPoint, radius: radius / cos(angle) , startAngle: .pi / 2 + angle, endAngle: 3 * .pi / 2 - angle, clockwise: true)
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
        let caloriesCircle = UIBezierPath(arcCenter: centerPoint, radius: radius / cos(angle) , startAngle: .pi / 2 - angle, endAngle: 3 * .pi / 2 + angle, clockwise: false)
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
    
    func drawCycleLayer(strokeColor:UIColor,cycleCircle:UIBezierPath) {
        
        let bgLayer = CAShapeLayer()
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = cycleWidth
        bgLayer.strokeColor = strokeColor.cgColor
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        bgLayer.lineCap = .round
        bgLayer.path = cycleCircle.cgPath
        self.layer.addSublayer(bgLayer)
       
       
    }
    
}
