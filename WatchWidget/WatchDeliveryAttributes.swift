//
//  WatchDeliveryAttributes.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/5/11.
//

import Foundation
import ActivityKit

struct WatchDeliveryAttributes: ActivityAttributes {
    
    public typealias WatchDeliveryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var second: Int
        var step:Int
        var distance:String
        var calories:String
    }
    var sportImageName: String
    var sportName:String

}
