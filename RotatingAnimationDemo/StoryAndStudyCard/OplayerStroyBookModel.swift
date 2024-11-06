//
//  OplayerStroyBookModel.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/10/18.
//

import UIKit

class OplayerStroyBookModel: NSObject {

    var storyName:String?
    
    var allFile:[OplayerFileModel] = []
    
    convenience init(storyName: String?, allFile: [OplayerFileModel]) {
        self.init()
        self.storyName = storyName
        self.allFile = allFile
    }
    
    override var description: String {
        return """
            storyName:\(String(describing: storyName))
            allFile:\(allFile)
        """
    }
}

class OplayerStudyCardModel: NSObject {
    
    var watchPreviewImageName:String?
    
    var watchPreviewImagePath:String?
    
    var appPreviewImageName:String?
    
    var appPreviewImagePath:String?
    
    var allFile:[OplayerFileModel] = []
    
    convenience init(watchPreviewImageName: String? , watchPreviewImagePath: String?, appPreviewImageName: String?, appPreviewImagePath: String?, allFile: [OplayerFileModel]) {
        self.init()
        self.watchPreviewImageName = watchPreviewImageName
        self.watchPreviewImagePath = watchPreviewImagePath
        self.appPreviewImageName = appPreviewImageName
        self.appPreviewImagePath = appPreviewImagePath
        self.allFile = allFile
    }
    
    override var description: String {
        return """
                watchPreviewImageName:\(String(describing: watchPreviewImageName))
                watchPreviewImagePath:\(String(describing: watchPreviewImagePath))
                appPreviewImageName:\(String(describing: appPreviewImageName))
                appPreviewImagePath:\(String(describing: appPreviewImagePath))
        
                allFile:\(allFile)
        """
    }
}


class OplayerFileModel:NSObject {
    
    var previewName:String?
    
    var imageName:String?
    
    var imagePath:String?
    
    var musicName:String?
    
    var musicPath:String?
    
    convenience init(previewName:String?,imageName: String?, imagePath: String?, musicName: String?, musicPath: String?) {
        self.init()
        self.previewName = previewName
        self.imageName = imageName
        self.imagePath = imagePath
        self.musicName = musicName
        self.musicPath = musicPath
    }
    
    override var description: String {
        return """
        
        previewName:\(String(describing: previewName))
        imageName:\(String(describing: imageName))
        imagePath:\(String(describing: imagePath))
        musicName:\(String(describing: musicName))
        musicPath:\(String(describing: musicPath))
        
        """
    }
    
}
