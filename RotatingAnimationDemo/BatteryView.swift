//
//  BatteryView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/6/27.
//

import UIKit

class BatteryView: UIView {

    var lineWidth: CGFloat = 4
    var cornerRadius: CGFloat = 12
    var headWidth: CGFloat = 12

    
    /// 电量百分比，范围 0~1
    var batteryLevel: CGFloat = 0.2 {
        didSet {
            setNeedsDisplay()
        }
    }
    convenience init(frame: CGRect,lineWidth:CGFloat,cornerRadius:CGFloat,headWidth:CGFloat) {
        self.init(frame: frame)
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.headWidth = headWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

    override func draw(_ rect: CGRect) {
       
        // 电池外框
        let bodyRect = CGRect(x: lineWidth/2,
                              y: lineWidth/2,
                              width: rect.width - headWidth - lineWidth,
                              height: rect.height - lineWidth)
        let bodyPath = UIBezierPath(roundedRect: bodyRect, cornerRadius: cornerRadius)
        bodyPath.lineWidth = lineWidth
        UIColor.black.setStroke()
        UIColor.clear.setFill()
        bodyPath.fill()
        bodyPath.stroke()

        // 电池头
        let headRect = CGRect(x: rect.width - headWidth,
                              y: rect.height * 0.25,
                              width: headWidth - lineWidth/2,
                              height: rect.height * 0.5)
        let headPath = UIBezierPath(roundedRect: headRect, cornerRadius: headWidth/2)
        headPath.lineWidth = lineWidth
        UIColor.black.set()
        
        headPath.stroke()
        headPath.fill()
        
        // 电量填充
        let padding: CGFloat = lineWidth * 2
        let fillHeight = bodyRect.height - padding * 2
        let fillWidth = (bodyRect.width - padding * 2) * max(0, min(batteryLevel, 1))
        let fillRect = CGRect(x: bodyRect.minX + padding,
                              y: bodyRect.minY + padding,
                              width: fillWidth,
                              height: fillHeight)
        let fillColor: UIColor = batteryLevel <= 0.2 ? .red : .green
        
        let fillPath = UIBezierPath(roundedRect: fillRect, cornerRadius:cornerRadius/2)
        
        fillColor.set()
        fillPath.stroke()
        fillPath.fill()
    }
}
