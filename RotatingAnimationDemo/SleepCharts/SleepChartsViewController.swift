//
//  SleepChartsViewController.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/8/31.
//

import UIKit

class SleepChartsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 30 5 30 5 30
        
        
        let sleepJohnView = SleepJointLayer(frame: CGRect(x: 100, y: 100, width: 11, height: 100), backGroundColorList: [UIColor.orange.cgColor,UIColor.yellow.cgColor], jointWidth: 1, jointHeight: 40, radius: 5,jointType: .leftBottom)
        self.view.layer.addSublayer(sleepJohnView)
        
        let sleepJohnView2 = SleepJointLayer(frame: CGRect(x: 111, y: 100, width: 11, height: 100), backGroundColorList: [UIColor.orange.cgColor,UIColor.yellow.cgColor], jointWidth: 1, jointHeight: 40, radius: 5,jointType: .leftTop)
        self.view.layer.addSublayer(sleepJohnView2)
        
        let sleepJohnView3 = SleepJointLayer(frame: CGRect(x: 122, y: 100, width: 11, height: 100), backGroundColorList: [UIColor.orange.cgColor,UIColor.yellow.cgColor], jointWidth: 1, jointHeight: 40, radius: 5,jointType: .leftBottom)
        self.view.layer.addSublayer(sleepJohnView3)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
