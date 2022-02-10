//
//  RotatingView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2021/11/9.
//

import UIKit

class RotatingView: UIView {

    
    var clickBlock:(() -> ())?
    
    lazy var topimageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var backImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var textLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//
//        self.isUserInteractionEnabled = true
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(viewHaveClick))
//        self.addGestureRecognizer(tap)
//
//
        
    }
    
    convenience init(frame:CGRect,backGroudImage:UIImage?,showImage:UIImage?,showText:NSAttributedString?) {
        self.init(frame: frame)
        
        
        topimageView.image = showImage
        backImageView.image = backGroudImage
        textLabel.attributedText = showText
        
        self.addSubview(backImageView)
        self.addSubview(topimageView)
        self.addSubview(textLabel)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backImageView.frame = self.bounds
        topimageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.6, height: self.bounds.size.height*0.6)
        topimageView.center = self.center
        
        textLabel.bounds = CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.8, height: self.bounds.size.height*0.8)
        textLabel.center = self.center
        
    }
    
}


