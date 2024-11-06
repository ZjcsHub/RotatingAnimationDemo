//
//  LockScrollView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/9/14.
//

import UIKit

class LockScrollView: UIView {

    var bottomSliderHeight:CGFloat = 44
    
    var darwColor:UIColor = UIColor.red
    
    var borderColor:UIColor = UIColor.white
    
    var progress: CGFloat = 0 {
        willSet {
            topSlider.snp.updateConstraints { (make) in
                make.width.equalTo(newValue * (bounds.size.width) + bottomSliderHeight)
            }
        }
    }
    
    private lazy var sliderCircle: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sporting_lock")
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
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = bottomSliderHeight / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    convenience init(frame: CGRect,bottomSliderHeight:CGFloat,darwColor:UIColor,borderColor:UIColor) {
        self.init(frame: frame)
        self.bottomSliderHeight = bottomSliderHeight
        self.darwColor = darwColor
        self.borderColor = borderColor
        addControls()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        addGestureRecognizer(pan)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LockScrollView {
    @objc func panGestureAction(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in: self)
        var width = translation.x + bottomSliderHeight
        if width > bounds.size.width  {
            width = bounds.size.width
        }
        if width < bottomSliderHeight {
            width = bottomSliderHeight
        }
        if pan.state == .changed {
           
            topSlider.snp.updateConstraints { (make) in
                make.width.equalTo(width)
            }
            
            
        }
        let value: CGFloat = width / (bounds.size.width)
        if pan.state == .ended {
            print("end")
            if width < bounds.size.width {
                progress = 0
            }else{
                print("解锁完成")
            }
            
//            progress = value
        }
        
    }
    
    func addControls() {
        
        addSubview(bottomSlider)
        bottomSlider.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        addSubview(topSlider)
        topSlider.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(bottomSlider)
            make.height.equalTo(bottomSlider.snp.height)
            make.width.equalTo(bottomSliderHeight)
        }
        
        addSubview(sliderCircle)
        sliderCircle.snp.makeConstraints { (make) in
            make.width.height.equalTo(bottomSliderHeight)
            make.centerY.equalToSuperview()
            make.right.equalTo(topSlider.snp.right)
        }
      
    }
    override func draw(_ rect: CGRect) {
//        topSlider.snp.updateConstraints { (make) in
//            make.width.equalTo(progress * (bounds.size.width - bottomSliderHeight / 2))
//        }
    }
}
