//
//  ViewController.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2021/11/9.
//

import UIKit
import ActivityKit

@available(iOS 16.1, *)
class ViewController: UIViewController {

    var timer:Timer?
    var second = 0
    var step = 0
    var distance:Double = 0
    var calories:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white

//        let agpsView = AgpsSyncingView.loadAgpsSyncView()
//        agpsView.layer.masksToBounds = true
//        agpsView.showAgpsSyncView(controller: self)
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            
//            self.view.setNeedsUpdateConstraints()
//            self.view.updateConstraintsIfNeeded()
//            
//            agpsView.snp.remakeConstraints { make in
//                make.top.equalTo(self.view.snp.top).offset(100)
//                make.left.equalTo(self.view.snp.left)
//                make.size.equalTo(CGSize(width: 50, height: 50))
//            }
//           
//            UIView.animate(withDuration: 2) {
//                self.view.layoutIfNeeded()
//            }
//            
//            
//           
//            
//        }
//      
//        let backView = GPSBackView(frame: CGRect(x: 0, y: 100, width: 200, height: 200))
//        self.view.addSubview(backView)
        
//        let scrollView = LockScrollView(frame: CGRect(x: 50, y: 100, width: self.view.bounds.size.width - 100, height: 40), bottomSliderHeight: 40, darwColor: UIColor.red, borderColor: .orange)
//        self.view.addSubview(scrollView)
//        
//        let displayView = GoalDisplayRotatView(frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width, height: self.view.bounds.size.width))
//        self.view.addSubview(displayView)
//        

//        let button1 = UIButton(type: .system)
//        button1.setTitle("开始灵动岛", for: .normal)
//        button1.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
//        button1.addTarget(self, action: #selector(start), for: .touchUpInside)
//        
//        let button2 = UIButton(type: .system)
//        button2.setTitle("结束灵动岛", for: .normal)
//        button2.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
//        button2.addTarget(self, action: #selector(end), for: .touchUpInside)
//
//        
//        self.view.addSubview(button1)
//        self.view.addSubview(button2)
        
        
//        let jsonPath = Bundle.main.path(forResource: "cities15000", ofType: "json")
//        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: jsonPath!))
//        let json = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [String:Any]
//        let listString = json!["data"] as? [[String]]
//        if var json = try! JSONSerialization.jsonObject(with: jsonData) as? [[Any]] {
//            
//            
//            let array = TimeZone.knownTimeZoneIdentifiers
//            
//            for identifier in array {
//                
//                print(identifier)
//                
//                json.removeAll { $0[2] as! String == identifier }
////                if let timeZone = TimeZone(identifier: identifier),let timeZoneName = identifier.components(separatedBy: "/").last  {
////                    
////                    let localizedName = timeZone.localizedName(for: .standard, locale: NSLocale.current)
////                    
////                    let cityAbbreviation = WorldClockTool.default.getCurrentCityAbbreviationBy(identifier: identifier, cityName: timeZoneName)
////                    
////                    let model = WorldClockModel(identifier:identifier, timeZoneName: timeZoneName, abbreviation: timeZone.abbreviation(), localizedName: localizedName,timeZoneSecond: timeZone.secondsFromGMT(), isSelect: false,cityAbbreviation: cityAbbreviation)
////                    
////                    worldClockLists.append(model)
////                }
//                
//            }
//            
//            json.removeAll { $0[2] as! String == "Asia/Kolkata" }
//            
//            print(json)
//            
//            
//            
//        }
//        
            
        
        
//        let timeZone = TimeZone(identifier: "Asia/Kolkata")
//        print(timeZone?.secondsFromGMT()) 
        
        
      
//        let weightView = LoseWeightRateView(frame: CGRect(x: 20, y: 100, width: self.view.bounds.size.width - 40, height: 40), bottomSliderHeight: 10, backGrawColor: .lightGray, darwColor: .red, borderColor: .white)
//        self.view.addSubview(weightView)
//        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 200, height: 320))
        imageView.backgroundColor = .red
        imageView.image = UIImage(named: "background")
        self.view.addSubview(imageView)
        
    }

    @objc func start() {
        
        let watchDeliveryAttributes = WatchDeliveryAttributes(sportImageName: "weekly_running_front", sportName: "Walking")
        
        let initialContentState = WatchDeliveryAttributes.WatchDeliveryStatus(second: 0, step: 0, distance: "0 Km", calories: "0 Kcal")
        
        
        do {
            
            let deliveryActivity = try Activity<WatchDeliveryAttributes>.request(
                attributes: watchDeliveryAttributes,
                contentState: initialContentState,
                pushType: .token)
            Task {
                for await pushToken in deliveryActivity.pushTokenUpdates {
                    let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
                    print(pushTokenString)
                }
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
                self.step += 1
                self.calories += 0.01
                self.distance += 0.01
                self.second += 1
                
                self.update()
            })
            
            
        }catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error)")
        }
        
        
        
    }
    
    @objc func end() {
        Task {
            for activity in Activity<WatchDeliveryAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }

            self.step = 0
            self.calories = 0
            self.distance = 0
            self.second = 0
            print("Cancelled all pizza delivery Live Activity")
        }
    }
    
    func update() {
        Task {
            let updatedDeliveryStatus = WatchDeliveryAttributes.WatchDeliveryStatus(second: self.second, step: self.step, distance: String(format: "%.2f km", self.distance), calories: String(format: "%.2f Kcal", self.calories))
            
            for activity in Activity<WatchDeliveryAttributes>.activities{
                await activity.update(using: updatedDeliveryStatus)
            }

            print("Updated pizza delivery Live Activity")
        }
    }

}

