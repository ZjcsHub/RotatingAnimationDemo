//
//  VideoMediaTools.swift
//  OplayerSport
//
//  Created by App005 SYNERGY on 2020/8/13.
//  Copyright © 2020 App005 SYNERGY. All rights reserved.
//

import Foundation
import AVFoundation
// 文字转语音
class VideoMediaTools: NSObject {
    
    static let `default` = VideoMediaTools()
  
    private var voice:AVSpeechSynthesizer!
    private var speekTextLists:[String] = []
    private var delaySecond = 0.5
    private override init() {
        super.init()
        voice = AVSpeechSynthesizer()
        voice.delegate = self
    }
    func readTextLists(textLists:[String],second:Double = 0.5) {
        delaySecond = second
        if speekTextLists.isEmpty {
            speekTextLists = textLists
        }else{
            speekTextLists.append(contentsOf: textLists)
        }
        
        // 开始奖
        if let firstString = textLists.first {
            readText(text: firstString)
        }
    }
    func readText(text:String)  {
        
        let speech = AVSpeechUtterance(string: text)
        // 音调调节
        speech.pitchMultiplier = 1
        // 音量调节
        speech.volume = 1
        // 语速
        speech.rate = 0.8
        
        let language = "zh"//InternationTools.default.getLanguageCode()
        let languageVoice = AVSpeechSynthesisVoice(language: language)
        speech.voice = languageVoice
        //
        speech.postUtteranceDelay = 0
        // 开始讲
        voice.speak(speech)
        
    }
    
    
}
extension VideoMediaTools : AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        if !speekTextLists.isEmpty {
            // 移除第一条
            speekTextLists.removeFirst()
            // 等待2秒
//            _ = DelayTask.delay(delaySecond) {
                if let firstString = self.speekTextLists.first {
                    self.readText(text: firstString)
                }
//            }
           
            
        }
        
    }
}

extension VideoMediaTools {
    
    static var music_id:SystemSoundID = 0
    
    
    static func playSound() {
        cancelSound()
        guard let musicPath = Bundle.main.path(forResource: "Alarm", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: musicPath)
        AudioServicesCreateSystemSoundID(url as CFURL, &music_id)
        
        AudioServicesPlayAlertSoundWithCompletion(music_id) {
            cancelSound()
        }
    }
    
    static func cancelSound() {
        AudioServicesDisposeSystemSoundID(music_id)
    }
    
}
