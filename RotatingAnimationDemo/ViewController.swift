//
//  ViewController.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2021/11/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .black
        
        let displayView = GoalDisplayRotatView(frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width, height: self.view.bounds.size.width))
        self.view.addSubview(displayView)
        
        
    }


}

