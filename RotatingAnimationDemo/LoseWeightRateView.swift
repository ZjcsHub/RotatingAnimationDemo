//
//  LoseWeightRateView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/9/21.
//

import UIKit

class LoseWeightRateView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var darwColor:UIColor = UIColor.red
    var bottomSliderHeight:CGFloat = 10
    var borderColor:UIColor = .white
    var backGrawColor:UIColor = .lightGray
    var progress: CGFloat = 0 {
        willSet {
            topSlider.snp.updateConstraints { (make) in
                make.width.equalTo(newValue * bottomSlider.bounds.size.width)
            }
        }
    }
    
    private lazy var sliderCircle: UIView = {
        let view = UIView()
        view.backgroundColor = darwColor
        view.layer.cornerRadius = bottomSliderHeight
        view.layer.masksToBounds = true
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var topSlider: UIView = {
        let view = UIView()
        view.backgroundColor = darwColor
        view.layer.cornerRadius = bottomSliderHeight / 2
        view.layer.masksToBounds = true
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var bottomSlider: UIView = {
        let view = UIView()
        view.backgroundColor = backGrawColor
        view.layer.cornerRadius = bottomSliderHeight / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var leftCycleView:UIView = {
        let view = UIView()
        view.backgroundColor = backGrawColor
        view.layer.cornerRadius = bottomSliderHeight
        view.layer.masksToBounds = true
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var middleCycleView:UIView = {
        let view = UIView()
        view.backgroundColor = backGrawColor
        view.layer.cornerRadius = bottomSliderHeight
        view.layer.masksToBounds = true
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var rightCycleView:UIView = {
        let view = UIView()
        view.backgroundColor = backGrawColor
        view.layer.cornerRadius = bottomSliderHeight
        view.layer.masksToBounds = true
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    convenience init(frame: CGRect,bottomSliderHeight:CGFloat,backGrawColor:UIColor,darwColor:UIColor,borderColor:UIColor) {
        self.init(frame: frame)
        self.bottomSliderHeight = bottomSliderHeight
        self.darwColor = darwColor
        self.borderColor = borderColor
        self.backGrawColor = backGrawColor
        addControls()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        addGestureRecognizer(pan)
    }
    @objc func panGestureAction(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in: self)
        var width = bottomSlider.bounds.size.width  * progress + translation.x + bottomSliderHeight
        if width > bottomSlider.bounds.size.width {
            width = bottomSlider.bounds.size.width
        }
        if width < 0 {
            width = 0
        }
        if pan.state == .changed {
           
            topSlider.snp.updateConstraints { (make) in
                make.width.equalTo(width)
            }
            
            
        }
        let value: CGFloat = width / bottomSlider.bounds.size.width
        if pan.state == .ended {
            
            print(value)
            
            if value < 0.25 {
                progress = 0
            }else if (value >= 0.25 && value <= 0.5) || (value >  0.5 && value <= 0.75) {
                progress = 0.5
            }else {
                progress = 1
            }
            
//            progress = value
          
        }
        
      
    }
    
    func addControls() {
        
        addSubview(bottomSlider)
        bottomSlider.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(bottomSliderHeight)
            make.right.equalTo(self.snp.right).offset(-bottomSliderHeight)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(bottomSliderHeight)
        }
        
        addSubview(topSlider)
        topSlider.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(bottomSlider)
            make.height.equalTo(bottomSlider.snp.height)
            make.width.equalTo(0)
        }
        
        addSubview(leftCycleView)
        addSubview(middleCycleView)
        addSubview(rightCycleView)
        
        leftCycleView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: bottomSliderHeight*2, height: bottomSliderHeight*2))
            make.left.equalTo(bottomSlider.snp.left).offset(-bottomSliderHeight)
            make.centerY.equalTo(bottomSlider.snp.centerY)
        }
        middleCycleView.snp.makeConstraints { make in
            make.size.equalTo(leftCycleView.snp.size)
            make.center.equalTo(bottomSlider.snp.center)
        }
        rightCycleView.snp.makeConstraints { make in
            make.right.equalTo(bottomSlider.snp.right).offset(bottomSliderHeight)
            make.size.equalTo(leftCycleView.snp.size)
            make.centerY.equalTo(bottomSlider.snp.centerY)
        }
        
        
        
        addSubview(sliderCircle)
        sliderCircle.snp.makeConstraints { (make) in
            make.width.height.equalTo(bottomSliderHeight*2)
            make.centerY.equalTo(bottomSlider.snp.centerY)
            make.left.equalTo(topSlider.snp.right).offset(-bottomSliderHeight)
        }
      
    }
    
}
