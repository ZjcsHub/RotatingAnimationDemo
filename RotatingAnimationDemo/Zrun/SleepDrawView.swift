//
//  SleepDrawView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/3/3.
//

import UIKit
// 睡眠状态枚举
enum SleepState {
    case awake      // 清醒
    case lightSleep // 浅睡
    case deepSleep  // 深睡
}

// 睡眠数据模型
struct SleepSegment {
    let state: SleepState
    let startTime: Date
    let duration: TimeInterval
}
class SleepDrawView: UIView {
    
  
    
    private var sleepSegments: [SleepSegment] = []
    private var bedTime: Date?
    private var wakeTime: Date?
    
    private let awakeColor = UIColor(red: 255/255, green: 151/255, blue: 125/255, alpha: 1)
    private let lightSleepColor = UIColor(red: 86/255, green: 157/255, blue: 255/255, alpha: 1)
    private let deepSleepColor = UIColor(red: 124/255, green: 77/255, blue: 255/255, alpha: 1)
    
    
    private var textFont:UIFont = UIFont.systemFont(ofSize: 12)
    private var bottomPadding:CGFloat = 30
    private var topPadding:CGFloat = 20
    private var leftPadding:CGFloat = 10
    private var textColor:UIColor = UIColor.gray
    private var rightPadding:CGFloat = 10
    
    override func layoutSubviews() {
        self.layer.sublayers?.forEach({ (sublayers) in
            sublayers.removeFromSuperlayer()
        })
        drawContent()
    }
    
    func drawContent() {
        let textAttribute:[NSAttributedString.Key: Any] =  [
            .font: textFont,
            .foregroundColor: textColor
        ]
        let awakeText = "清醒"
       
        let awakeSize = awakeText.size(withAttributes: textAttribute)
        
        let lightSleep = "浅睡"
        let lightSize = lightSleep.size(withAttributes: textAttribute)
        
        let deepSleep = "深睡"
        let deepSize = deepSleep.size(withAttributes: textAttribute)
        
        let maxWidth = max(awakeSize.width, lightSize.width,deepSize.width)
        
        
        let drawHeight = self.bounds.size.height - topPadding - bottomPadding
        let subItemHeight = drawHeight / 2
        let drawOriginY = topPadding
        let awakePoint = CGPoint(x: maxWidth + leftPadding - awakeSize.width , y: drawOriginY - awakeSize.height / 2)
                
        let lightPoint = CGPoint(x: maxWidth + leftPadding - lightSize.width, y: drawOriginY + subItemHeight - lightSize.height / 2)
        
        let deepPoint = CGPoint(x: maxWidth + leftPadding - deepSize.width, y: drawOriginY + subItemHeight * 2 - deepSize.height / 2)
        
        
        let awakeTextLayer = getTextLayer(text: awakeText)
        awakeTextLayer.frame = CGRect(origin: awakePoint, size: awakeSize)
        self.layer.addSublayer(awakeTextLayer)
        
        let lightTextLayer = getTextLayer(text: lightSleep)
        lightTextLayer.frame = CGRect(origin: lightPoint, size: lightSize)
        self.layer.addSublayer(lightTextLayer)
        
        let deepTextLayer = getTextLayer(text: deepSleep)
        deepTextLayer.frame = CGRect(origin: deepPoint, size: deepSize)
        self.layer.addSublayer(deepTextLayer)
        
        
        // 绘制虚线
        makeLineLayer(maxWidth: maxWidth, drawOriginY: drawOriginY)
        makeLineLayer(maxWidth: maxWidth, drawOriginY: drawOriginY + subItemHeight)
        makeLineLayer(maxWidth: maxWidth, drawOriginY: drawOriginY + subItemHeight * 2)
        
        
        
    }
    
    private func makeLineLayer(maxWidth:CGFloat,drawOriginY:CGFloat) {
        let lineWidth = self.bounds.size.width - maxWidth - leftPadding - rightPadding - leftPadding
        let awakeBezier =  UIBezierPath()
        let lineStartX = maxWidth + leftPadding + leftPadding
        awakeBezier.move(to: CGPoint.init(x: lineStartX, y: drawOriginY))
        awakeBezier.addLine(to: CGPoint.init(x: lineStartX + lineWidth, y: drawOriginY))
        let awakeLineLayer = getLineLayer()
        awakeLineLayer.path = awakeBezier.cgPath
        self.layer.addSublayer(awakeLineLayer)
        
    }
    
    
    private func getLineLayer() -> CAShapeLayer {
        let lineBgLayer = CAShapeLayer()
        lineBgLayer.fillColor = textColor.cgColor
        lineBgLayer.lineWidth = 0.5
        lineBgLayer.strokeColor = textColor.cgColor
        lineBgLayer.strokeStart = 0
        lineBgLayer.strokeEnd = 1
        lineBgLayer.lineCap = .square
        lineBgLayer.lineDashPattern = [NSNumber(floatLiteral: 5),NSNumber(floatLiteral: 3)]
        return lineBgLayer
    }
    
    
    func getTextLayer(text:String) -> CATextLayer {
       
        let textLayer = CATextLayer()
        textLayer.contentsScale = 2.0
        textLayer.isWrapped = true
        let font = textFont
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.foregroundColor = textColor.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.string = text
        return textLayer
    }
    
    func setSleepData(segments: [SleepSegment], bedTime: Date, wakeTime: Date) {
        self.sleepSegments = segments
        self.bedTime = bedTime
        self.wakeTime = wakeTime
        setNeedsDisplay()
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
       
        
        
        
//        var bedString = "--"
//        var awakeString = "--"
//        if let wakeTime , let bedTime {
//            let totalDuration = wakeTime.timeIntervalSince(bedTime)
//            let drawWidth = rect.width - horizontalPadding * 2
//        }
//      
//        
//        // 绘制时间标签
//
//        let bedTimeString = timeFormatter.string(from: bedTime)
//        let wakeTimeString = timeFormatter.string(from: wakeTime)
//        
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: textFont,
//            .foregroundColor: UIColor.gray
//        ]
        
//        bedTimeString.draw(at: CGPoint(x: horizontalPadding - 20, y: rect.height - 15), 
//                         withAttributes: attributes)
//        wakeTimeString.draw(at: CGPoint(x: rect.width - horizontalPadding, y: rect.height - 15), 
//                         withAttributes: attributes)
        
        // 绘制3个状态
//        let awakeText = "清醒"
//        let textAttribute:[NSAttributedString.Key: Any] =  [
//            .font: textFont,
//            .foregroundColor: UIColor.gray
//        ]
//        let awakeSize = awakeText.size(withAttributes: textAttribute)
//        
//        let lightSleep = "浅睡"
//        let lightSize = lightSleep.size(withAttributes: textAttribute)
//        
//        let deepSleep = "深睡"
//        let deepSize = deepSleep.size(withAttributes: textAttribute)
//        
//        let maxWidth = max(awakeSize.width, lightSize.width,deepSize.width)
//        
//        
//        let drawHeight = rect.height - topPadding - bottomPadding
//        let subItemHeight = drawHeight / 2
//        let drawOriginY = topPadding
//        let awakePoint = CGPoint(x: maxWidth + leftPadding - awakeSize.width , y: drawOriginY - awakeSize.height / 2)
//        awakeText.draw(at: awakePoint, withAttributes: textAttribute)
//        
//        let lightPoint = CGPoint(x: maxWidth + leftPadding - lightSize.width, y: drawOriginY + subItemHeight - lightSize.height / 2)
//        lightSleep.draw(at:lightPoint, withAttributes: textAttribute)
//        
//        let deepPoint = CGPoint(x: maxWidth + leftPadding - deepSize.width, y: drawOriginY + subItemHeight * 2 - deepSize.height / 2)
//        deepSleep.draw(at: deepPoint, withAttributes: textAttribute)
//
//        // 绘制虚线
//        let lineDash: [CGFloat] = [5.0, 3.0]
//        context.setLineDash(phase: 0, lengths: lineDash)
//        context.setStrokeColor(UIColor.lightGray.cgColor)
//        context.setLineWidth(1)
//        
//        context.move(to: CGPoint(x: maxWidth + leftPadding, y: verticalPadding))
//        context.addLine(to: CGPoint(x: currentX + segmentWidth, y: verticalPadding))
//        
//        for segment in sleepSegments {
//            let segmentWidth = (drawWidth * segment.duration) / totalDuration
//           
//            context.strokePath()
//        }
//        
//        
        
        
//        // 绘制睡眠状态段
//        var currentX = horizontalPadding
//        
//        for segment in sleepSegments {
//            let segmentWidth = (drawWidth * segment.duration) / totalDuration
//            let segmentRect = CGRect(x: currentX,
//                                   y: verticalPadding,
//                                   width: segmentWidth,
//                                   height: segmentHeight)
//            
//            let color: UIColor
//            switch segment.state {
//            case .awake:
//                color = awakeColor
//            case .lightSleep:
//                color = lightSleepColor
//            case .deepSleep:
//                color = deepSleepColor
//            }
//            
//            let path = UIBezierPath(roundedRect: segmentRect, cornerRadius: 5)
//            color.setFill()
//            path.fill()
//            
//            currentX += segmentWidth
//        }
//        
//        // 绘制虚线连接
//        let lineDash: [CGFloat] = [5.0, 3.0]
//        context.setLineDash(phase: 0, lengths: lineDash)
//        context.setStrokeColor(UIColor.lightGray.cgColor)
//        context.setLineWidth(1)
//        
//        for segment in sleepSegments {
//            let segmentWidth = (drawWidth * segment.duration) / totalDuration
//            context.move(to: CGPoint(x: currentX, y: verticalPadding))
//            context.addLine(to: CGPoint(x: currentX + segmentWidth, y: verticalPadding))
//            context.strokePath()
//        }
    }
}
