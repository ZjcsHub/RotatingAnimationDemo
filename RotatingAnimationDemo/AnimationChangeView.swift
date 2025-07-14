//
//  AnimationChangeView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/7/7.
//

import UIKit

class AnimationChangeView: UIView {

    lazy var imageView: UIImageView = UIImageView()
    let normalImage = UIImage(named: "glasses_icon_disconnect")
    let selectImage = UIImage(named: "glasses_icon_connect")
    private var isSelected = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.image = normalImage
        imageView.isUserInteractionEnabled = true
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tap)
    }

    @objc private func imageTapped() {
        if isSelected {
            // 向右旋转回normalImage
            UIView.animate(withDuration: 0.25, animations: {
                self.imageView.layer.transform = CATransform3DMakeRotation(.pi / 2, 0, 1, 0)
            }) { _ in
                self.imageView.image = self.normalImage
                UIView.animate(withDuration: 0.25, animations: {
                    self.imageView.layer.transform = CATransform3DIdentity
                })
            }
        } else {
            // 向左旋转到selectImage
            UIView.animate(withDuration: 0.25, animations: {
                self.imageView.layer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 1, 0)
            }) { _ in
                self.imageView.image = self.selectImage
                UIView.animate(withDuration: 0.25, animations: {
                    self.imageView.layer.transform = CATransform3DIdentity
                })
            }
        }
        isSelected.toggle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
