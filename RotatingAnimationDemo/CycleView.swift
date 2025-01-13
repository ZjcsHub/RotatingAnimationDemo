//
//  StepCycleView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/12/27.
//

import UIKit

class CycleView: UIView {
    
    // MARK: - Properties
    private let totalTicks = 40 // 总刻度数
    private let tickLength: CGFloat = 20 // 刻度长度
    private let tickWidth: CGFloat = 2 // 刻度宽度
    private var progress: CGFloat = 0 // 进度值 (0-1)
    
    private let defaultColor: UIColor = .lightGray // 默认颜色
    private let progressColor: UIColor = .blue // 进度颜色
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    // MARK: - Public Methods
    func setProgress(_ value: CGFloat) {
        progress = min(max(value, 0), 1)
        setNeedsDisplay()
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.maxY)
        let radius = min(bounds.width, bounds.height) - tickLength
        
        // 计算每个刻度的角度
        let totalAngle: CGFloat = .pi // 180度（半圆）
        let tickSpacing = totalAngle / CGFloat(totalTicks - 1)
        
        // 绘制所有刻度
        for i in 0..<totalTicks {
            let angle = CGFloat(i) * tickSpacing
            let startAngle = .pi - (totalAngle / 2) + angle
            
            let startPoint = CGPoint(
                x: center.x + radius * cos(startAngle),
                y: center.y - radius * sin(startAngle)
            )
            
            let endPoint = CGPoint(
                x: center.x + (radius + tickLength) * cos(startAngle),
                y: center.y - (radius + tickLength) * sin(startAngle)
            )
            
            // 创建刻度线路径
            let tickPath = UIBezierPath()
            tickPath.move(to: startPoint)
            tickPath.addLine(to: endPoint)
            tickPath.lineWidth = tickWidth
            
            // 设置刻度颜色
            let progressTicks = CGFloat(totalTicks) * progress
            let color = CGFloat(i) <= progressTicks ? progressColor : defaultColor
            color.setStroke()
            
            // 绘制刻度线
            tickPath.stroke()
        }
    }
}
