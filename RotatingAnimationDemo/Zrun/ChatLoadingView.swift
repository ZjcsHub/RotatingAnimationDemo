//
//  ChatLoadingView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/3/21.
//

import UIKit

class ChatLoadingView: UIView {
    
    private var isAnimating = false
    private var animationLayers: [CAShapeLayer] = []
    private var voiceWaveView: VoiceWaveView?
    let startAngle = Double.pi * 7 / 6
    let endAngle =  Double.pi * 11 / 6
    let centerAngle = Double.pi / 3
    public var drawColor:UIColor = .blue {
        didSet {
            voiceWaveView?.backgroundColor = drawColor
        }
    }
    
    lazy var showBottomLabel:UILabel = {
        let label = UILabel()
        label.text = "松开发送"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var setUpCycleView:Void = {
        drawBottomCycleView()
        let waveViewSize = CGSize(width: 80, height: 40)
        let radius = self.bounds.size.width/2
        let y = self.bounds.size.height + cos(centerAngle) * radius - radius - waveViewSize.height - 60
        voiceWaveView?.frame = CGRect(
            x: (bounds.width - waveViewSize.width) / 2,
            y:y,
            width: waveViewSize.width,
            height: waveViewSize.height
        )
        
        self.addSubview(showBottomLabel)
        showBottomLabel.frame = CGRect(x:0,y:self.bounds.size.height - 40,width:self.bounds.size.width,height:25)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVoiceWaveView()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.layer.masksToBounds = true
        
       
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setUpCycleView
        
        // 更新声波视图位置
      
    }
    
    func drawBottomCycleView() {
        // 绘制一个底部半圆
        let radius = self.bounds.size.width/2
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height + cos(centerAngle) * radius)
        let shadowPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let bgLayer = CAShapeLayer()
        bgLayer.frame = self.bounds
        bgLayer.fillColor = drawColor.cgColor
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        bgLayer.path = shadowPath.cgPath
        self.layer.addSublayer(bgLayer)
    }
    
    // MARK: - 波纹动画相关方法
    
    func startWaveAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        // 开始声波动画
        voiceWaveView?.startAnimating()
        
        // 原有的波纹动画代码...
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self, self.isAnimating else {
                timer.invalidate()
                return
            }
            self.createWaveLayer()
        }
        createWaveLayer()
    }
    
    func stopWaveAnimation() {
        isAnimating = false
        // 停止声波动画
        voiceWaveView?.stopAnimating()
        
        // 原有的停止代码...
        animationLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        animationLayers.removeAll()
    }
    
    private func createWaveLayer() {
        let radius = self.bounds.size.width/2
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height + cos(centerAngle) * radius)
        let lineWidth = 50.0
        // 创建波纹层
        let waveLayer = CAShapeLayer()
        waveLayer.frame = self.bounds
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.strokeColor = drawColor.withAlphaComponent(0.5).cgColor
//        waveLayer.lineWidth = lineWidth
        
      
        // 初始路径
        let initialPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle:endAngle, clockwise: true)
        
        // 结束路径（更大的半径）
        let finalPath = UIBezierPath(arcCenter: center, radius: radius + lineWidth / 2, startAngle: startAngle - Double.pi / 6, endAngle: endAngle + Double.pi / 6, clockwise: true)
        
        waveLayer.path = initialPath.cgPath
        
        self.layer.insertSublayer(waveLayer, below: self.layer.sublayers?.first)
        animationLayers.append(waveLayer)
        
        // 创建动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.0
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        // 路径动画（替换原来的缩放动画）
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = initialPath.cgPath
        pathAnimation.toValue = finalPath.cgPath
        
        // 线宽动画（让线条随着扩展变细）
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = 0
        lineWidthAnimation.toValue = lineWidth
        
        // 透明度动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0.0
        
        animationGroup.animations = [ lineWidthAnimation,pathAnimation, opacityAnimation]
        
        // 动画完成后移除层
        animationGroup.completion = { [weak self] _ in
            waveLayer.removeFromSuperlayer()
            self?.animationLayers.removeAll { $0 == waveLayer }
        }
        
        waveLayer.add(animationGroup, forKey: "rippleEffect")
    }
    
    private func setupVoiceWaveView() {
        // 调整声波视图的大小和位置
        let waveViewSize = CGSize(width: 80, height: 40) // 稍微增加尺寸
        let waveViewX = (bounds.width - waveViewSize.width) / 2
        let waveViewY = bounds.height / 2 - 100 // 调整到更上方的位置
        
        voiceWaveView = VoiceWaveView(frame: CGRect(x: waveViewX, 
                                                   y: waveViewY, 
                                                   width: waveViewSize.width, 
                                                   height: waveViewSize.height))
        voiceWaveView?.backgroundColor = drawColor
        if let voiceWaveView = voiceWaveView {
            addSubview(voiceWaveView)
        }
    }
}

// MARK: - CAAnimationGroup 扩展
extension CAAnimationGroup {
    var completion: ((Bool) -> Void)? {
        get { return nil }
        set {
            if let newValue = newValue {
                delegate = AnimationDelegate(completion: newValue)
            }
        }
    }
}

// MARK: - 动画代理
private class AnimationDelegate: NSObject, CAAnimationDelegate {
    let completion: (Bool) -> Void
    
    init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion(flag)
    }
}

// MARK: - 声波动画视图
class VoiceWaveView: UIView {
    private var barLayers: [CALayer] = []
    private var displayLink: CADisplayLink?
    private var lastUpdateTime: CFTimeInterval = 0
    private let updateInterval: CFTimeInterval = 0.1 // 更新间隔时间
    private let barCount = 5
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8 // 添加圆角效果
        setupBars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBars()
    }
    
    private func setupBars() {
        // 移除现有的bars
        barLayers.forEach { $0.removeFromSuperlayer() }
        barLayers.removeAll()
        
        let barWidth: CGFloat = 4
        let barSpacing: CGFloat = 4
        let totalWidth = CGFloat(barCount) * (barWidth + barSpacing) - barSpacing
        var xOffset = (bounds.width - totalWidth) / 2
        
        for _ in 0..<barCount {
            let barLayer = CALayer()
            barLayer.backgroundColor = UIColor.white.cgColor
            // 修改初始位置，使用bounds.height而不是0
            barLayer.frame = CGRect(x: xOffset, 
                                  y: bounds.height/2, 
                                  width: barWidth, 
                                  height: 0)
            // 修改锚点位置到中心
            barLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            layer.addSublayer(barLayer)
            barLayers.append(barLayer)
            
            xOffset += barWidth + barSpacing
        }
    }
    
    func startAnimating() {
        guard !isAnimating else { return }
        isAnimating = true
        lastUpdateTime = 0
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateBars))
        // 设置帧率为60/3=20fps
//        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 40, maximum: 40, preferred: 40)
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopAnimating() {
        isAnimating = false
        displayLink?.invalidate()
        displayLink = nil
        
        // 重置所有bar的高度
        barLayers.forEach { layer in
            layer.removeAllAnimations()
            layer.frame.size.height = 0
        }
    }
    
    @objc private func updateBars() {
        let currentTime = CACurrentMediaTime()
        guard (currentTime - lastUpdateTime) >= updateInterval else { return }
        
        for (index, barLayer) in barLayers.enumerated() {
            let animation = CABasicAnimation(keyPath: "bounds.size.height")
            let height = CGFloat.random(in: 5...20)
            animation.fromValue = barLayer.frame.height
            animation.toValue = height
            // 增加动画持续时间
            animation.duration = 0.8
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            // 确保高度变化时保持居中
            barLayer.frame.size.height = height
            barLayer.frame.origin.y = bounds.height/2
            
            barLayer.add(animation, forKey: "height")
            // 增加延迟时间
            animation.beginTime = CACurrentMediaTime() + Double(index) * 0.05
        }
        
        lastUpdateTime = currentTime
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let barWidth: CGFloat = 4
        let barSpacing: CGFloat = 4
        let totalWidth = CGFloat(barCount) * (barWidth + barSpacing) - barSpacing
        var xOffset = (bounds.width - totalWidth) / 2
        
        for barLayer in barLayers {
            barLayer.frame.origin.x = xOffset
            // 修改Y轴位置到视图中心
            barLayer.frame.origin.y = bounds.height/2 - barSpacing
            barLayer.frame.size.width = barWidth
            xOffset += barWidth + barSpacing
        }
    }
}
