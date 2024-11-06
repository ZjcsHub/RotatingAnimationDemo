//
//  WidgetDemo.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/5/11.
//

import SwiftUI
import ActivityKit
import WidgetKit

@available(iOS 16.2, *)
@main
struct Widgets: WidgetBundle {
    var body: some Widget {
        WatchActivityWidget()
    }
}
@available(iOS 16.2, *)
struct WatchActivityWidget: Widget {
    
    func getTimeStringBySecond(seconds:Int) -> String {
        
        //format of hour
        let str_hour = String(format: "%02d", seconds/3600)
        //format of minute
        let str_minute = String(format: "%02d", (seconds%3600)/60)
        //format of second
        let str_second = String(format: "%02d", seconds%60)
        //format of time
        let format_time = String(format: "%@:%@:%@", str_hour,str_minute,str_second)
        
        return format_time
        
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WatchDeliveryAttributes.self) { context in
            
            VStack {
                HStack {
                    Text("Oplayer Smart Life")
                        .bold()
                }
                HStack(alignment: .center, content: {
                    Image(context.attributes.sportImageName)
                        .resizable()
                        .frame(width: 100,height: 100)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                       
                    VStack(alignment: .leading, content: {
                        HStack(content: {
                            Text("Step:")
                                .bold()
                            Text("\(context.state.step)")
                            
                        })
                        HStack(content: {
                            Text("Distance:")
                                .bold()
                            Text(context.state.distance)
                        })
                        HStack(content: {
                            Text("Calories:")
                                .bold()
                            Text(context.state.calories)
                        })
                        
                        HStack {
                            Text("Time:")
                                .bold()
                            Text(getTimeStringBySecond(seconds: context.state.second))
                        }
                    })
                })
               
                
            }.padding()
            
               
                        
            
        } dynamicIsland: { context in
            
            DynamicIsland {
                
                DynamicIslandExpandedRegion(.center) {
                    Text(context.attributes.sportName + " " + context.state.distance)
                       
                    Text(getTimeStringBySecond(seconds: context.state.second))
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                                
            } compactLeading: {
                Text(context.attributes.sportName)
            } compactTrailing: {
                Text(getTimeStringBySecond(seconds: context.state.second))
            } minimal: {
                Text("\(context.state.second)")
            }

        }

    }
}
@available(iOS 16.2, *)
struct WatchActivityWidget_Previews: PreviewProvider {
    
    static let activityAttributes = WatchDeliveryAttributes(sportImageName: "biger_running", sportName: "Running")
    
    static let activityState = WatchDeliveryAttributes.ContentState(second: 10, step: 100, distance: "23 km", calories: "23 kcal")
    
    static var previews: some View {
      
        activityAttributes.previewContext(activityState, viewKind: .content)
                .previewDisplayName("Notification")
        
        activityAttributes.previewContext(activityState, viewKind: .dynamicIsland(.compact))
                .previewDisplayName("Compact")

        activityAttributes.previewContext(activityState, viewKind: .dynamicIsland(.expanded))
                .previewDisplayName("Expanded")

        
        activityAttributes.previewContext(activityState, viewKind: .dynamicIsland(.minimal))
                .previewDisplayName("Minimal")


    }
    
}
