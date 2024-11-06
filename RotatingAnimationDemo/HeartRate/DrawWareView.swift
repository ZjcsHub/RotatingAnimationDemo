//
//  HeartRateDrawView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/11/5.
//

import UIKit

enum DrawWareLineType {
    case heartRate
    case stress
}

class DrawWareView: UIView {

    private var cellSize:CGSize = CGSize(width: 5, height: 5)
    
    private var cellLineWidth:CGFloat = 1
    
    private var cellCount:Int = 30
    
    private var inside:UIEdgeInsets = .zero
    
    private var dataList:[CGFloat] = []
    
    private var drawHeight:CGFloat = 80
    
    private var timer:CADisplayLink?
    
    private var drawNumberList:[CGFloat] = []
    
    private var currentIndex:Int = 0
    
    private var drawColor:UIColor = .red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    convenience init(frame: CGRect,drawHeight:CGFloat,drawColor:UIColor,drawType:DrawWareLineType) {
        self.init(frame: frame)
        self.drawHeight = drawHeight / 2
        self.drawColor = drawColor
        
        if drawType == .heartRate {
            for i in 0...90 {
                if i / 30 == 1 {
                    dataList.append(self.drawHeight * sin(CGFloat(i) * 1.0/30.0 * Double.pi * 2))
                    
                }else{
                    dataList.append(self.drawHeight / 2 * sin(CGFloat(i) * 1.0/30.0 * Double.pi * 2))
                }
            }
            dataList.append(contentsOf: Array(repeating: 0, count: 20))
        }else if drawType == .stress {
            let startIndex = 30
            for i in 0..<90 {
                
                // 中间 29...60 采用另外一种正选
                if i < startIndex {
                    let drawY = self.drawHeight * sin(CGFloat(i) * 1.0/60.0 * Double.pi * 2)
                    dataList.append(drawY)
                }else if i >= startIndex && i < startIndex + 30 {
                    
                    let height = self.drawHeight * sin(CGFloat(startIndex) * 1.0/60.0 * Double.pi * 2)
                    let y = self.drawHeight / 3 * sin(CGFloat(i-startIndex) * 1.0/CGFloat(30) * Double.pi * 2 + Double.pi) + height
                    dataList.append(y)
                   
                    
                }else{
                    let drawY = self.drawHeight * sin(CGFloat(i - 30) * 1.0/60.0 * Double.pi * 2)
                    dataList.append(drawY)
                }
                
                
               
            }
            
            
        }
        
      
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    lazy var drawBackView:Void = {
        let viewWidth = self.bounds.size.width
        
        let viewHeight = self.bounds.size.height
        
        let lineColor = UIColor.lightGray.withAlphaComponent(0.4)
        
        for i in 0 ..< Int(viewWidth) {
            let linePath = UIBezierPath()
            let startIndex = inside.left + CGFloat(i) * cellSize.width
            if startIndex > viewWidth - inside.right {
                break
            }
            let startPoint = CGPoint(x: startIndex, y: inside.top)
            let endPoint = CGPoint(x: startPoint.x, y: viewHeight - inside.bottom)
            linePath.move(to: startPoint)
            linePath.addLine(to: endPoint)
            
            let lineLayer = CAShapeLayer()
            lineLayer.fillColor = lineColor.cgColor
            lineLayer.lineWidth = cellLineWidth
            lineLayer.strokeEnd = 1
            lineLayer.strokeStart = 0
            lineLayer.strokeColor = lineColor.cgColor
            lineLayer.path = linePath.cgPath
            
            self.layer.addSublayer(lineLayer)
            
        }
        
        for i in 0 ..< Int(viewHeight) {
            let linePath = UIBezierPath()
            let startIndex = inside.top + cellSize.height * CGFloat(i)
            if startIndex > viewHeight - inside.bottom {
                break
            }
            let startPoint = CGPoint(x: inside.left , y: startIndex)
            let endPoint = CGPoint(x: viewWidth - inside.right, y: startPoint.y)
            linePath.move(to: startPoint)
            linePath.addLine(to: endPoint)
            
            let lineLayer = CAShapeLayer()
            lineLayer.fillColor = lineColor.cgColor
            lineLayer.lineWidth = cellLineWidth
            lineLayer.strokeEnd = 1
            lineLayer.strokeStart = 0
            lineLayer.strokeColor = lineColor.cgColor
            lineLayer.path = linePath.cgPath
            
            self.layer.addSublayer(lineLayer)
            
        }
    }()
    
    func startTimer() {
        timer = CADisplayLink(target: self, selector: #selector(update))
        timer?.add(to: .main, forMode: .common)
    }
   
     @objc private func update() {
        
        if currentIndex >= dataList.count {
            currentIndex = 0
        }
        
        let value = dataList[currentIndex]
        
        
        if drawNumberList.count >= Int(self.bounds.size.width) {
            drawNumberList.removeFirst()
        }
        
        drawNumberList.append(value)
        
        currentIndex += 1
        
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
       
        _ = drawBackView
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)

//        // 绘制波形
        let path = UIBezierPath()
        for i in 0..<drawNumberList.count {
            let x = CGFloat(i)
            let y = rect.height / 2 - drawNumberList[i]
            
            if i == 0 {
                path.move(to: CGPoint(x: 0, y: rect.height / 2))
            }
            path.addLine(to: CGPoint(x: x, y: y))
        }
        drawColor.setStroke()
        path.stroke()
        
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
