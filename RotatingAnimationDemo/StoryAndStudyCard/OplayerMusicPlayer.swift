//
//  OplayerMusicPlayer.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/10/19.
//

import UIKit
import AVFoundation

protocol OplayerMusicPlayerDelegate : NSObjectProtocol {
    
    func netPlayerHavePlayEnd()
    
    func localPlayerHavePlayEnd()
    
}

class OplayerMusicPlayer: NSObject  {

        
    var localAudioPlayer:AVAudioPlayer?
    
    var netAudioPlayer:AVPlayer?
    
    weak var delegate:OplayerMusicPlayerDelegate?
    
    override init() {
        super.init()
    }
    
    func playLocalFile(url:URL) {
        print("local url : \(url)")
        localAudioPlayer = try? AVAudioPlayer(contentsOf: url)
        localAudioPlayer?.delegate = self
        if localAudioPlayer != nil {
            localAudioPlayer?.play()
        }
    }
    
    func playNetWorkFile(netUrl:URL?) {
        
        guard let netUrl else {
            return
        }
        
        print("net url :\(netUrl)")
        
        let playerItem = AVPlayerItem(url: netUrl)
               
        if netAudioPlayer != nil {
            
            netAudioPlayer?.replaceCurrentItem(with: playerItem)
//            netAudioPlayer?.actionAtItemEnd = .pause
            return
        }
        
       
        netAudioPlayer = AVPlayer(playerItem: playerItem)
        netAudioPlayer?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification: )), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
   
    
    func stopPlayer() {
        localAudioPlayer?.stop()
        localAudioPlayer = nil
        
        netAudioPlayer?.pause()
        netAudioPlayer = nil
    }
    
   
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            if playerItem == netAudioPlayer?.currentItem {
                // 播放结束时执行的操作
                print("播放结束")
                self.delegate?.netPlayerHavePlayEnd()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension OplayerMusicPlayer:AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("本地音频播放结束")
        self.delegate?.localPlayerHavePlayEnd()

    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: (any Error)?) {
        print("audioPlayerDecodeErrorDidOccur")
    }
    
    
}
