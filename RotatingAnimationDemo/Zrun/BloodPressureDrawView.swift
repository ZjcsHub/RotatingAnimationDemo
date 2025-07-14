//
//  BloodPressureDrawView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/3/3.
//

import UIKit

class BloodPressureDrawView: UIView {
    
    // 存储舒张压和收缩压的值
    var diastolicPressure: Int? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var systolicPressure: Int? {
        didSet {
            setNeedsDisplay()
        }
    }
    private let drawFont = UIFont.systemFont(ofSize: 9)
    private let maxValue: CGFloat = 200
    private let minValue: CGFloat = 0
    private let lineWidth: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 绘制背景刻度
        drawScale(in: context, rect: rect)
        
        // 如果血压值都存在，则绘制血压区间
        if let diastolic = diastolicPressure, let systolic = systolicPressure {
            drawBloodPressureRange(in: context, rect: rect, diastolic: diastolic, systolic: systolic)
        }
    }
    
    private func drawScale(in context: CGContext, rect: CGRect) {
        let centerX = rect.width / 2
        let height = rect.height - 20 // 留出上下边距
        
        // 绘制外框
        let path = UIBezierPath(roundedRect: CGRect(x: centerX - lineWidth/2,
                                                   y: 10,
                                                   width: lineWidth,
                                                   height: height),
                               cornerRadius: 5)
        UIColor.lightGray.withAlphaComponent(0.3).setFill()
        path.fill()
        
        // 绘制刻度
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(1)
        
        // 计算刻度间隔
        let mmHgInterval: CGFloat = 10 // mmHg刻度间隔
        // 刻度线与柱形的间距
        let linePadding:CGFloat = 3
        
        let longLineWidth:CGFloat = 10
        
        let shoreLineWidth:CGFloat = 5
      
        // 绘制左侧mmHg刻度
        for value in stride(from: 0, through: Int(maxValue), by: Int(mmHgInterval)) {
            let y = 10 + height * (1 - CGFloat(value) / maxValue)
            
            let isLong = value % 20 == 0
            
            // 绘制刻度线
            context.move(to: CGPoint(x: centerX - lineWidth/2 - linePadding , y: y))
            context.addLine(to: CGPoint(x: centerX - lineWidth/2 - linePadding - (isLong ? longLineWidth : shoreLineWidth), y: y))
            context.strokePath()
            
            if !isLong {
                continue
            }
            
            // 绘制刻度值
            let valueString = "\(value)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: drawFont,
                .foregroundColor: UIColor.gray
            ]
            let size = valueString.size(withAttributes: attributes)
            valueString.draw(at: CGPoint(x: centerX - lineWidth/2 - size.width - linePadding - longLineWidth - 3,
                                       y: y - size.height/2),
                           withAttributes: attributes)
        }
        

        // 绘制右侧kPa刻度
        for value in stride(from: 0, through: 26, by: 1) {
            // 将kPa转换为对应的mmHg高度位置
            let mmHgValue = CGFloat(value) * 7.5
            let y = 10 + height * (1 - mmHgValue / maxValue)
            
            let isLong = value % 2 == 0
            // 绘制刻度线
            context.move(to: CGPoint(x: centerX + lineWidth/2 + linePadding, y: y))
            context.addLine(to: CGPoint(x: centerX + lineWidth/2 + linePadding + (isLong ? longLineWidth : shoreLineWidth), y: y))
            context.strokePath()
            
            if !isLong {
                continue
            }
            // 绘制刻度值
            let valueString = "\(value)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: drawFont,
                .foregroundColor: UIColor.gray
            ]
            let size = valueString.size(withAttributes: attributes)
            valueString.draw(at: CGPoint(x: centerX + lineWidth/2 + linePadding + longLineWidth + 3,
                                       y: y - size.height/2),
                           withAttributes: attributes)
        }
 
    }
    
    private func drawBloodPressureRange(in context: CGContext,
                                      rect: CGRect,
                                      diastolic: Int,
                                      systolic: Int) {
        let centerX = rect.width / 2
        let height = rect.height - 20
        
        // 计算血压值对应的位置
        let diastolicY = 10 + height * (1 - CGFloat(diastolic) / maxValue)
        let systolicY = 10 + height * (1 - CGFloat(systolic) / maxValue)
        
        // 绘制血压范围
        let rangePath = UIBezierPath(roundedRect: CGRect(x: centerX - lineWidth/2,
                                                        y: systolicY,
                                                        width: lineWidth,
                                                        height: diastolicY - systolicY),
                                    cornerRadius: 5)
        UIColor.orange.withAlphaComponent(0.8).setFill()
        rangePath.fill()
    }
}
