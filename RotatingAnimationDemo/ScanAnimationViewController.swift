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
//        let scanAnimationView = ScanAnimationView(frame: CGRect(x: (self.view.bounds.size.width - 240) / 2, y: 100, width: 240, height: 240), spaceWidth: 40, lineColor: UIColor.cyan, centerImage: UIImage(named: "weekly_running_back"))
//        self.view.addSubview(scanAnimationView)
        
//        let stepCycleView = StepCycleView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.width / 2 + 50), drawBackColor: .lightGray, drawColor: .red, lineWidth: 10, bottomPadding: 30)//StepCycleView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.width / 2 + 50))
//        stepCycleView.progress = 0.6
        
        let stepCycleView = SquareStepView(frame: CGRect(x: 0, y: 100, width: 200, height: 200 + 20), stepBackColor: .yellow.withAlphaComponent(0.5), stepDrawColor: .green, distanceBackColor: .blue.withAlphaComponent(0.5), distanceDrawColor: .blue, caloriesBackColor: .red.withAlphaComponent(0.5), caloriesDrawColor: .red, lineWidth: 15)
        
        stepCycleView.stepProgress = 0.8
        stepCycleView.caloriesProgress = 0.3
        stepCycleView.distanceProgress = 0.7
        
        
        self.view.addSubview(stepCycleView)
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
