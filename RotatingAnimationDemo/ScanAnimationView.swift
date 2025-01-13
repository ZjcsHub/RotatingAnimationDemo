//
//  ScanAnimationView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/6/7.
//

import UIKit

class ScanAnimationView: UIView {

    lazy var baseLayer:CALayer = CALayer()
    
    private var spaceWidth:CGFloat = 30
    
    private var lineColor:UIColor = UIColor.blue
    
    private var centerImage:UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        // baseLayer
        baseLayer.frame = self.bounds
        self.layer.addSublayer(baseLayer)
                
       
    }
    
    convenience init(frame: CGRect,spaceWidth:CGFloat,lineColor:UIColor,centerImage:UIImage?) {
        self.init(frame: frame)
        self.spaceWidth = spaceWidth
        self.lineColor = lineColor
        self.centerImage = centerImage
        
        drawGradientRings()
      

        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    private func drawGradientRings() {
        // 绘制渐变圆环
        let center = CGPoint(x: self.bounds.size.width / 2 , y: self.bounds.size.height / 2)
        
       
        // 创建渐变色图层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width / 2, height: self.bounds.size.height / 2)
        gradientLayer.colors = [lineColor.cgColor,lineColor.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0,  0.5, 1]
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        baseLayer.addSublayer(gradientLayer)
        
        // 添加遮罩
        let path = UIBezierPath(arcCenter: center, radius: self.bounds.size.width / 2, startAngle: Double.pi * 3 / 2 - Double.pi / 12, endAngle: Double.pi * 3 / 2, clockwise: true)
        path.addLine(to: center)
        path.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = lineColor.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.path = path.cgPath
        gradientLayer.mask = shapeLayer
        
    }
    
    private func drawConnectingLine() {
        
        // 画一条线
        let center = CGPoint(x: self.bounds.size.width / 2 , y: self.bounds.size.height / 2)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: self.bounds.size.height / 2))
        linePath.addLine(to: center)
        
        // 线层
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.fillColor = lineColor.cgColor
        lineLayer.lineWidth = 2
        lineLayer.strokeStart = 0
        lineLayer.strokeEnd = 1
        lineLayer.path = linePath.cgPath
        baseLayer.addSublayer(lineLayer)
        
    }
    
    private func startAnimation() {
        //动画
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.duration = 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        baseLayer.add(rotationAnimation, forKey: "rotationAnnimation")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 绘制几个线圈
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let lineWidth:CGFloat = 2
            
        let halfPathWidth = rect.size.width / 2
        var drawCount:CGFloat = 0
        let drawColor = UIColor.lightGray
        while (spaceWidth + lineWidth) * drawCount < halfPathWidth {
            
            
            
            let outpath = UIBezierPath(arcCenter: center, radius: halfPathWidth - lineWidth / 2 - (drawCount * (spaceWidth)), startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
            outpath.lineWidth = lineWidth
            drawColor.withAlphaComponent(0.1+drawCount*0.1).setFill()
            drawColor.withAlphaComponent(0.1+drawCount*0.1).setStroke()
            outpath.stroke()
            outpath.fill()
            drawCount += 1
        }
        
       
        
    }
    
}
