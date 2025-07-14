//
//  ConnectWifiTool.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/6/4.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class ConnectWifiTool: NSObject {
    
    // 连接WiFi的方法
    static func connectToWiFi(ssid: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        // 创建WiFi配置
        let configuration = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        
        // 设置加入一次性
        configuration.joinOnce = true
        
        // 连接WiFi
        NEHotspotConfigurationManager.shared.apply(configuration) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // 断开指定WiFi的方法
    static func disconnectWiFi(ssid: String) {
        NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: ssid)
    }
    
    // 断开所有配置的WiFi的方法
    static func disconnectAllWiFi() {
        NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "*")
    }
    
    // 获取当前连接的WiFi信息
    static func getCurrentWiFiInfo() -> (ssid: String?, bssid: String?) {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return (nil, nil)
        }
        
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any] else {
                continue
            }
            
            let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
            let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
            
            return (ssid, bssid)
        }
        
        return (nil, nil)
    }
    
    // 获取当前连接的WiFi SSID
    static func getCurrentWiFiSSID() -> String? {
        return getCurrentWiFiInfo().ssid
    }
    
    // 获取当前连接的WiFi BSSID（MAC地址）
    static func getCurrentWiFiBSSID() -> String? {
        return getCurrentWiFiInfo().bssid
    }
    
    // 检查是否连接到指定WiFi
    static func isConnectedToWiFi(ssid: String) -> Bool {
        guard let currentSSID = getCurrentWiFiSSID() else {
            return false
        }
        return currentSSID == ssid
    }
    
    // 检查是否连接到WiFi网络
    static func isConnectedToWiFi() -> Bool {
        return getCurrentWiFiSSID() != nil
    }

}
