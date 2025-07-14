//
//  TsMdeiaTool.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/6/17.
//

import UIKit
import AVFoundation

class TsMdeiaTool: NSObject {
    static let `default` = TsMdeiaTool()
    
    /// 获取TS视频文件的预览图
    /// - Parameters:
    ///   - videoURL: 视频文件URL
    ///   - time: 要获取预览图的时间点(秒)，默认为0.5秒
    ///   - completion: 完成回调，返回预览图或错误信息
    func getVideoPreviewImage(videoURL: URL, atTime time: Double = 0.5, completion: @escaping (UIImage?, Error?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let timePoint = CMTimeMakeWithSeconds(time, preferredTimescale: 600)
        
        DispatchQueue.global().async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: timePoint, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
