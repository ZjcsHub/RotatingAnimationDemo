//
//  HeartRateViewController.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/11/5.
//

import UIKit

class HeartRateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let heartRateWaveView = HeartRateDrawView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        let heartRateWaveView = DrawWareView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 80), drawHeight: 60, drawColor: .red, drawType: .heartRate)
        view.addSubview(heartRateWaveView)
        
        heartRateWaveView.startTimer()
        
        
        let stressView = DrawWareView(frame: CGRect(x: 0, y: 400, width: view.bounds.width, height: 80), drawHeight: 60, drawColor: .blue, drawType: .stress)
        view.addSubview(stressView)
        stressView.startTimer()
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
