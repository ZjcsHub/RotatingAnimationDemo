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
        
//        let stepCycleView = SquareStepView(frame: CGRect(x: 0, y: 100, width: 200, height: 200 + 20), stepBackColor: .yellow.withAlphaComponent(0.5), stepDrawColor: .green, distanceBackColor: .blue.withAlphaComponent(0.5), distanceDrawColor: .blue, caloriesBackColor: .red.withAlphaComponent(0.5), caloriesDrawColor: .red, lineWidth: 15)
//        
//        stepCycleView.stepProgress = 0.8
//        stepCycleView.caloriesProgress = 0.3
//        stepCycleView.distanceProgress = 0.7
//        
//        
//        self.view.addSubview(stepCycleView)
//        
//        
//        DispatchQueue.global().async {
//        
//            let timer = Timer(timeInterval: 3, repeats: true) { _ in
//                print("timer 触发")
//        
//            }
//            
//            RunLoop.main.add(timer, forMode: .common)
//            
//        }
        
        
        let sleepView = SleepDrawView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        sleepView.backgroundColor = .clear
        view.addSubview(sleepView)

//        // 创建测试数据
//        let bedTime = Date() // 入睡时间
//        let wakeTime = bedTime.addingTimeInterval(8 * 3600) // 8小时后醒来
//
//        let segments = [
//            SleepSegment(state: .awake, startTime: bedTime, duration: 1800),
//            SleepSegment(state: .lightSleep, startTime: bedTime.addingTimeInterval(1800), duration: 3600),
//            SleepSegment(state: .deepSleep, startTime: bedTime.addingTimeInterval(5400), duration: 7200)
//        ]
//
//        sleepView.setSleepData(segments: segments, bedTime: bedTime, wakeTime: wakeTime)

        
//        let bloodPressureView = BloodPressureDrawView(frame: CGRect(x: 0, y: 100, width: 120, height: 250))
//        bloodPressureView.backgroundColor = .clear
//        bloodPressureView.diastolicPressure = 80  // 设置舒张压
//        bloodPressureView.systolicPressure = 120  // 设置收缩压
//        view.addSubview(bloodPressureView)
        
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
