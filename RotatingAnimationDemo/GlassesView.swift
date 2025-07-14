//
//  GlassesView.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/7/2.
//

import UIKit
import SceneKit

class GlassesView: UIView {
    private var sceneView: SCNView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScene()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScene()
    }

    private func setupScene() {
        sceneView = SCNView(frame: self.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.backgroundColor = .clear
        self.addSubview(sceneView)

        // 加载usdz模型
        if let url = Bundle.main.url(forResource: "glasses", withExtension: "usdz") {
            let scene = try? SCNScene(url: url, options: nil)
            sceneView.scene = scene
            sceneView.allowsCameraControl = true // 允许用户旋转缩放
            sceneView.autoenablesDefaultLighting = true // 自动光照
            
        } else {
            print("未找到glasses.usdz文件")
        }
    }
}
