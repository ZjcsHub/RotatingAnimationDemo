//
//  MapDistanveLineView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/3/14.
//

import UIKit

// 定义显示方向的枚举
enum DisplayOrientation {
    case horizontal
    case vertical
}

class MapDistanveLineView: UIView {
    // 定义用于显示文字的 UILabel
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return label
    }()

    // 左边/上边箭头的 CAShapeLayer
    private let topOrLeftArrowLayer = CAShapeLayer()
    // 右边/下边箭头的 CAShapeLayer
    private let bottomOrRightArrowLayer = CAShapeLayer()

    // 外部可配置的显示方向属性
    var orientation: DisplayOrientation = .horizontal {
        didSet {
            setNeedsLayout()
        }
    }

    // 外部可配置的线条颜色属性
    var lineColor: UIColor = .black {
        didSet {
            updateLineColor()
        }
    }

    // 外部可配置的文字颜色属性
    var textColor: UIColor = .black {
        didSet {
            textLabel.textColor = textColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupArrowLayers()
        updateLineColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        setupArrowLayers()
        updateLineColor()
    }

    // 设置子视图
    private func setupViews() {
        addSubview(textLabel)
    }

    // 设置约束
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 文字标签的约束
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // 设置箭头图层
    private func setupArrowLayers() {
        topOrLeftArrowLayer.fillColor = UIColor.clear.cgColor
        topOrLeftArrowLayer.lineWidth = 2
        layer.addSublayer(topOrLeftArrowLayer)

        bottomOrRightArrowLayer.fillColor = UIColor.clear.cgColor
        bottomOrRightArrowLayer.lineWidth = 2
        layer.addSublayer(bottomOrRightArrowLayer)
    }

    // 更新线条颜色
    private func updateLineColor() {
        topOrLeftArrowLayer.strokeColor = lineColor.cgColor
        bottomOrRightArrowLayer.strokeColor = lineColor.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawArrows()
        adjustTextOrientation()
    }

    // 绘制箭头
    private func drawArrows() {
        let labelFrame = textLabel.frame
        let centerX = labelFrame.midX
        let centerY = labelFrame.midY

        switch orientation {
        case .horizontal:
            // 绘制左边箭头
            let leftPath = UIBezierPath()
            leftPath.move(to: CGPoint(x: labelFrame.minX, y: centerY))
            leftPath.addLine(to: CGPoint(x: 0, y: centerY))
            leftPath.addLine(to: CGPoint(x: 10, y: centerY - 5))
            leftPath.move(to: CGPoint(x: 0, y: centerY))
            leftPath.addLine(to: CGPoint(x: 10, y: centerY + 5))
            topOrLeftArrowLayer.path = leftPath.cgPath

            // 绘制右边箭头
            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: labelFrame.maxX, y: centerY))
            rightPath.addLine(to: CGPoint(x: bounds.maxX, y: centerY))
            rightPath.addLine(to: CGPoint(x: bounds.maxX - 10, y: centerY - 5))
            rightPath.move(to: CGPoint(x: bounds.maxX, y: centerY))
            rightPath.addLine(to: CGPoint(x: bounds.maxX - 10, y: centerY + 5))
            bottomOrRightArrowLayer.path = rightPath.cgPath
        case .vertical:
            // 考虑 label 旋转后的实际位置和尺寸
            let rotatedLabelMinX = centerX - labelFrame.height / 2
            let rotatedLabelMaxX = centerX + labelFrame.height / 2
            let rotatedLabelMinY = centerY - labelFrame.width / 2
            let rotatedLabelMaxY = centerY + labelFrame.width / 2

            // 绘制上边箭头
            let topPath = UIBezierPath()
            topPath.move(to: CGPoint(x: centerX, y: rotatedLabelMinY))
            topPath.addLine(to: CGPoint(x: centerX, y: 0))
            topPath.addLine(to: CGPoint(x: centerX - 5, y: 10))
            topPath.move(to: CGPoint(x: centerX, y: 0))
            topPath.addLine(to: CGPoint(x: centerX + 5, y: 10))
            topOrLeftArrowLayer.path = topPath.cgPath

            // 绘制下边箭头
            let bottomPath = UIBezierPath()
            bottomPath.move(to: CGPoint(x: centerX, y: rotatedLabelMaxY))
            bottomPath.addLine(to: CGPoint(x: centerX, y: bounds.maxY))
            bottomPath.addLine(to: CGPoint(x: centerX - 5, y: bounds.maxY - 10))
            bottomPath.move(to: CGPoint(x: centerX, y: bounds.maxY))
            bottomPath.addLine(to: CGPoint(x: centerX + 5, y: bounds.maxY - 10))
            bottomOrRightArrowLayer.path = bottomPath.cgPath
        }
    }

    // 调整文字方向
    private func adjustTextOrientation() {
        switch orientation {
        case .horizontal:
            textLabel.transform = .identity
        case .vertical:
            textLabel.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }
    }

    // 提供一个公共方法来设置显示的文字
    func setText(_ text: String) {
        textLabel.text = text
    }
}
