//
//  ScanAnimationViewController.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/6/7.
//

import UIKit

class ScanAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let scanAnimationView = ScanAnimationView(frame: CGRect(x: (self.view.bounds.size.width - 240) / 2, y: 100, width: 240, height: 240), spaceWidth: 40, lineColor: UIColor.cyan, centerImage: UIImage(named: "weekly_running_back"))
        self.view.addSubview(scanAnimationView)
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
