//
//  ButtonScrollView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/4/17.
//

import UIKit

protocol ButtonScrollViewDelegate: AnyObject {
    func buttonScrollView(_ scrollView: ButtonScrollView, didSelectButtonAt index: Int)
}

class ButtonScrollView: UIView {
    
    // MARK: - 属性
    private let scrollView = UIScrollView()
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = 0
    
    weak var delegate: ButtonScrollViewDelegate?
    
    // 按钮样式配置
    var buttonSpacing: CGFloat = 10.0
    var buttonHeight: CGFloat = 40.0
    var buttonPadding: CGFloat = 15.0
    var cornerRadius: CGFloat = 18.0
    
    // 默认状态颜色
    var defaultBackgroundColor: UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    var defaultTextColor: UIColor = UIColor.darkGray
    
    // 选中状态颜色
    var selectedBackgroundColor: UIColor = UIColor(red: 90/255, green: 130/255, blue: 250/255, alpha: 1.0)
    var selectedTextColor: UIColor = UIColor.white
    
    // 按钮标题
    var titles: [String] = [] {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollView()
    }
    
    // MARK: - 设置UI
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    lazy var setDefaultIndex:Void = {
        updateButtonSelection(at: 0)
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setDefaultIndex
    }
    
    private func setupButtons() {
        // 清除现有按钮
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        var xOffset: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let button = createButton(withTitle: title, tag: index)
            
            // 计算按钮宽度（根据文字长度自适应）
            let buttonWidth = calculateButtonWidth(forTitle: title)
            
            button.frame = CGRect(x: xOffset, y: 0, width: buttonWidth, height: buttonHeight)
            scrollView.addSubview(button)
            buttons.append(button)
            
            xOffset += buttonWidth + buttonSpacing
        }
        
        // 设置滚动视图的内容大小
        scrollView.contentSize = CGSize(width: xOffset - buttonSpacing, height: buttonHeight)
        
//        // 默认选中第一个按钮
//        if !buttons.isEmpty {
//            updateButtonSelection(at: 0)
//        }
    }
    
    private func createButton(withTitle title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = defaultBackgroundColor
        button.setTitleColor(defaultTextColor, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func calculateButtonWidth(forTitle title: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let textWidth = (title as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
        return textWidth + (buttonPadding * 2)
    }
    
    
    
    // MARK: - 按钮点击处理
    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        updateButtonSelection(at: index)
        delegate?.buttonScrollView(self, didSelectButtonAt: index)
    }
    
    private func updateButtonSelection(at index: Int) {
        guard index >= 0 && index < buttons.count else { return }
        
        // 重置所有按钮状态
        for (i, button) in buttons.enumerated() {
            if i == index {
                button.backgroundColor = selectedBackgroundColor
                button.setTitleColor(selectedTextColor, for: .normal)
            } else {
                button.backgroundColor = defaultBackgroundColor
                button.setTitleColor(defaultTextColor, for: .normal)
            }
        }
        
        selectedIndex = index
        
        // 滚动到选中的按钮
        scrollToButton(at: index)
    }
    
    private func scrollToButton(at index: Int) {
        guard index >= 0 && index < buttons.count else { return }
        
        let button = buttons[index]
        let buttonFrame = button.frame
        
        // 计算滚动位置，使按钮居中显示
        let scrollViewWidth = scrollView.frame.width
        var offsetX = buttonFrame.midX - (scrollViewWidth / 2)
        
        // 确保不会滚动超出内容范围
        offsetX = max(0, min(offsetX, scrollView.contentSize.width - scrollViewWidth))
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    // MARK: - 公共方法
    func selectButton(at index: Int) {
        updateButtonSelection(at: index)
    }
    
    func getCurrentSelectedIndex() -> Int {
        return selectedIndex
    }
}
