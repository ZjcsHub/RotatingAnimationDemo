//
//  StepCycleView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/12/27.
//

import UIKit

class StepCycleView: UIView {

    private var cycleWidth:CGFloat = 10
    private var viewPadding:CGFloat = 10
    
    private let cycleCount = 40
    
    private var bottomPadding:CGFloat = 20
         
    // 绘画layer
    private var shapeLayer:CAShapeLayer = CAShapeLayer()
    private var clockDrawLayer:CAShapeLayer = CAShapeLayer()
    
    private var drawColor:UIColor = .red
    private var drawBackColor:UIColor = UIColor.lightGray
    
    public var progress:Double = 0{
        didSet {
            shapeLayer.strokeEnd = progress
             
            let drawNum = Int(Double(cycleCount + 1) * progress)
            
            clockDrawLayer.strokeEnd = Double(drawNum+1) / Double(cycleCount + 1)
        }
    }
    
    convenience init(frame: CGRect,drawBackColor:UIColor,drawColor:UIColor,lineWidth:CGFloat=10,bottomPadding:CGFloat) {
        self.init(frame: frame)
        self.cycleWidth = lineWidth
        self.drawBackColor = drawBackColor
        self.drawColor = drawColor
        self.bottomPadding = bottomPadding
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.sublayers?.forEach({ (sublayers) in
            sublayers.removeFromSuperlayer()
        })
        drawCycleView()
    }
    
    
    func drawCycleView()  {
        let viewWidth = self.frame.size.width
        let viewHeight = self.frame.size.height
        let radius = viewWidth / 2 - viewPadding - cycleWidth / 2
        
        let centerPoint = CGPoint(x: viewWidth / 2, y: viewHeight - bottomPadding)
        
        //外层虚线
        let lineCircle =  UIBezierPath(arcCenter: centerPoint, radius: viewWidth / 2 - 2 , startAngle: .pi, endAngle: .pi * 2, clockwise: true)
        
        let lineBgLayer = CAShapeLayer()
        lineBgLayer.frame = self.bounds
        lineBgLayer.fillColor = UIColor.clear.cgColor
        lineBgLayer.lineWidth = 1
        lineBgLayer.strokeColor = drawBackColor.cgColor
        lineBgLayer.strokeStart = 0
        lineBgLayer.strokeEnd = 1
        lineBgLayer.lineCap = .square
        lineBgLayer.lineDashPattern = [NSNumber(floatLiteral: 5),NSNumber(floatLiteral: 3)]
        lineBgLayer.path = lineCircle.cgPath
        self.layer.addSublayer(lineBgLayer)
        
        
        
        // 圆环进度
        let cycleCircle = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: .pi, endAngle: .pi * 2, clockwise: true)
    
        
    
        let bgLayer = CAShapeLayer()
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = cycleWidth
        bgLayer.strokeColor = drawBackColor.cgColor
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        bgLayer.lineCap = .round
        bgLayer.path = cycleCircle.cgPath
        self.layer.addSublayer(bgLayer)
        
        
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = cycleWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = drawColor.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = progress
        shapeLayer.path = cycleCircle.cgPath
        self.layer.addSublayer(shapeLayer)
        
        // 画刻度
        let clock = UIBezierPath()
        let pai:CGFloat = CGFloat(Double.pi)
        
        let clockRadius = radius-viewPadding
        let clockLineLength:CGFloat = 20
        for i in 0 ... cycleCount {
            let angle = CGFloat(i) / CGFloat(cycleCount) * pai
            // 圆上点
            let x = centerPoint.x - clockRadius * cos(angle)
            let y = centerPoint.y - clockRadius * sin(angle)
            clock.move(to: CGPoint(x: x, y: y))
            // 刻度线的另一端
           
            let x1 = centerPoint.x - (clockRadius - clockLineLength) * cos(angle)
            let y1 = centerPoint.y - (clockRadius - clockLineLength) * sin(angle)
            clock.addLine(to: CGPoint(x: x1, y: y1))

        }
        
        let clockBackLayer = CAShapeLayer()
        clockBackLayer.frame = self.bounds
        clockBackLayer.fillColor = UIColor.clear.cgColor
        clockBackLayer.strokeColor = drawBackColor.cgColor
        clockBackLayer.strokeStart = 0
        clockBackLayer.strokeEnd = 1
        clockBackLayer.lineWidth = cycleWidth / 2
        clockBackLayer.path = clock.cgPath
        self.layer.addSublayer(clockBackLayer)
        
        
        
        
        clockDrawLayer.frame = self.bounds
        clockDrawLayer.fillColor = UIColor.clear.cgColor
        clockDrawLayer.strokeColor = drawColor.cgColor
        clockDrawLayer.strokeStart = 0
        clockDrawLayer.strokeEnd = progress
        clockDrawLayer.lineWidth = cycleWidth / 2
        clockDrawLayer.path = clock.cgPath
        self.layer.addSublayer(clockDrawLayer)
    }

}
