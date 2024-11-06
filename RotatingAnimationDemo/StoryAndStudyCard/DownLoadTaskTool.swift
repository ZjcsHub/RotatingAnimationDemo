//
//  DownLoadTaskTool.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/10/18.
//

import UIKit

enum WatchSDCardType {
    case story
    case studyCard
}

enum OplayerWatchFileType {
    case image      // 图片
    case file       // 文件
}

class DownLoadTaskTool: NSObject {
    static let shared = DownLoadTaskTool()
    
    private var storyFolderName:String = "watch_story"
    
    private var session:URLSession!

    private var studyCardFloderName:String = "watch_study_card"
    
    private var currentWatchType:WatchSDCardType = .studyCard
    
    private let queue = OperationQueue()
    
    private let imageTypeList = ["png","jpg","jpeg","bmp","webp"]
    
    private let musicTypeList = ["mp3","wav","aac","oga","ogg","m4a","amr"]
    
    private override init() {
        super.init()
        queue.maxConcurrentOperationCount = 3

        createFolder()
        

    }

    
    /// 获取类型的保存路径
    /// - Parameter type: 类型
    /// - Returns: 路径
    private func getSaveFileName(type:WatchSDCardType) -> String {
        
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return ""
        }
        
        switch type {
        case .story:
            return documentPath + "/" + storyFolderName
        case .studyCard:
            return documentPath + "/" + studyCardFloderName
        }
        
    }
    
    /// 创建保存文件夹
    private func createFolder() {

        let fileManager = FileManager.default
        
        let storyName = getSaveFileName(type: .story)
        
        let studyCardName = getSaveFileName(type: .studyCard)
        
        if !fileManager.fileExists(atPath: storyName) {
            // 创建文件夹
            try? fileManager.createDirectory(atPath: storyName, withIntermediateDirectories: true, attributes: nil)
        }
        
        if !fileManager.fileExists(atPath: studyCardName) {
            // 创建文件夹
            try? fileManager.createDirectory(atPath: studyCardName, withIntermediateDirectories: true, attributes: nil)
        }
        
        
    }
    
    public func cancelDownload() {
        queue.cancelAllOperations()
    }
    
    /// 获取文件夹下所有文件
    /// - Parameter flodPath: 文件夹路径
    /// - Returns: 文件名
    private func getAllFileOfFloder(flodPath:String) -> [String] {
        let fileManager = FileManager.default
        
        let items = try? fileManager.contentsOfDirectory(atPath: flodPath)

        return items ?? []
    }
    
    /// 批量下载
    /// - Parameters:
    ///   - urls: 路径
    ///   - itemComplete: 每个子项完成回调
    ///   - progress: 进度
    ///   - completion: 完成回调
    private func downUrls(urlTuple: (previewImageUrls:[URL],filesUrls:[URL]),itemComplete:@escaping (_ f:URL,_ t:URL,_ isPreviewImage:Bool) -> Void, progress: @escaping (Float) -> Void,completion: @escaping () -> Void) {
        var completeCount = 0
        let fileurls = urlTuple.filesUrls
        let previewImages = urlTuple.previewImageUrls
        let totalCount = fileurls.count + previewImages.count

        for url in previewImages {
            let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error) in
                completeCount += 1
                if let localURL {
                    itemComplete(localURL,url,true)
                }
                progress(Float(completeCount) / Float(totalCount))

                if completeCount == totalCount {
                    completion()
                }
                
                
            })
            
            queue.addOperation(operation)
        }
        
        
        for url in fileurls {
            let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error) in
                completeCount += 1
                if let localURL {
                    itemComplete(localURL,url,false)
                }
                progress(Float(completeCount) / Float(totalCount))

                if completeCount == totalCount {
                    completion()
                }
            })
            
            queue.addOperation(operation)
        }
    }
    
    private func isImage(name:String) -> Bool {
        return self.imageTypeList.contains(name.lowercased())
    }
    
    private func dealWithAllFileData(files:[String],basePath:String) -> [OplayerFileModel] {
        var fileList:[OplayerFileModel] = []
        for file in files {
            let name = file.components(separatedBy: ".")
            guard let n1 = name.first , let n2 = name.last else {
                continue
            }
            
            if let firstModel = fileList.first(where: { $0.previewName == n1 }) {
                
                
                if self.isImage(name: n2) {
                    
                    firstModel.imageName = file
                    firstModel.imagePath = basePath + "/" + file
                    
                }else{
                    firstModel.musicName = file
                    firstModel.musicPath = basePath + "/" + file
                }
                
                
            }else{
                
                let firstModel = OplayerFileModel(previewName: n1, imageName: nil, imagePath: nil, musicName: nil, musicPath: nil)
                if self.isImage(name: n2) {
                    firstModel.imageName = file
                    firstModel.imagePath = basePath + "/" + file
                }else{
                    firstModel.musicName = file
                    firstModel.musicPath = basePath + "/" + file
                }
                
                
                if let index = fileList.firstIndex(where: { m in
                    if let previewName = m.previewName , let nM1 = Int(previewName) , let nM2 = Int(n1) {
                        return nM1 > nM2
                    }else if let previewName = m.previewName {
                        return previewName > n1
                    }else{
                        return false
                    }
                }) {
                    
                    fileList.insert(firstModel, at: index)
                    
                }else{
                    fileList.append(firstModel)
                }
            }
        }
        
        return fileList
        
        
    }
    
}

extension DownLoadTaskTool {
    
    /// 根据故事书名获取本地存储的文件
    /// - Parameters:
    ///   - storyName: 故事名
    ///   - complete: 完成回调
    public func getStoryBookModel(storyName:String,languageCode:String,complete:((OplayerStroyBookModel?) -> ())?) {
        
        let fileManager = FileManager.default
        
        let storyBookParentName = getSaveFileName(type: .story)
        
        let currentStoryName = storyBookParentName + "/" + languageCode + "/" + storyName
        
        guard fileManager.fileExists(atPath: currentStoryName) else {
            complete?(nil)
            return
        }
        
            
        DispatchQueue.global().async {
            let files = self.getAllFileOfFloder(flodPath: currentStoryName)

            let allFileList = self.dealWithAllFileData(files: files, basePath: currentStoryName)
            
            let storyBook = OplayerStroyBookModel(storyName: storyName, allFile: allFileList)

            DispatchQueue.main.async {
                complete?(storyBook)
            }
        }
        
        
    }
    
    
    /// 获取学习卡名
    /// - Parameters:
    ///   - studyCardName: 学习卡名
    ///   - complete: 完成回调
    public func getStudyCardModel(studyCardName:String,languageCode:String,complete:((OplayerStudyCardModel?) -> ())?) {
        
        let fileManager = FileManager.default
        
        let studyCardParentName = getSaveFileName(type: .studyCard)
        
        let currentStudyCardName = studyCardParentName + "/" + languageCode + "/" + studyCardName
        
        guard fileManager.fileExists(atPath: currentStudyCardName) else {
            complete?(nil)
            return
        }
        DispatchQueue.global().async {
            let files = self.getAllFileOfFloder(flodPath: currentStudyCardName)
                        
            let items = self.getAllFileOfFloder(flodPath: studyCardParentName + "/" + languageCode)
            
            let watchImageName = items.first(where: { $0.hasPrefix(studyCardName+".") })
            
            var watchPreviewImagePath:String?
            
            if let watchImageName {
                watchPreviewImagePath = studyCardParentName + "/" + languageCode + "/" + watchImageName
            }
            
            let appImageName = items.first(where: { $0.hasPrefix(studyCardName+"_app") })
            
            var appPreviewImagePath:String?
            
            if let appImageName {
                appPreviewImagePath = studyCardParentName + "/" + languageCode + "/" + appImageName
            }
            
            let allFileList = self.dealWithAllFileData(files: files, basePath: currentStudyCardName)
            
            let studyCardModel = OplayerStudyCardModel(watchPreviewImageName: watchImageName, watchPreviewImagePath: watchPreviewImagePath, appPreviewImageName: appImageName, appPreviewImagePath: appPreviewImagePath, allFile: allFileList)
            
            DispatchQueue.main.async {
                complete?(studyCardModel)
            }
        }
        
        
        
        
    }
    
    /// 下载故事书
    /// - Parameters:
    ///   - urls: 故事书链接
    ///   - storyName: 故事书名
    ///   - progress: 进度
    ///   - completion: 完成回调
    public func dowmLoadStoryBook(urls:[URL],storyName:String,languageCode:String,progress: @escaping (Float) -> Void, completion: @escaping (String) -> Void) {
        
        let fileManager = FileManager.default
        
        let storyBookParentName = getSaveFileName(type: .story)
        
        let currentStoryName = storyBookParentName + "/" + languageCode + "/" + storyName
        
        // 1. 先判断语言文件夹
        if !fileManager.fileExists(atPath: storyBookParentName + "/" + languageCode) {
            try? fileManager.createDirectory(atPath: storyBookParentName + "/" + languageCode, withIntermediateDirectories: true, attributes: nil)
        }
        
        // 1.2 判断故事书文件夹
        if !fileManager.fileExists(atPath: currentStoryName) {
            try? fileManager.createDirectory(atPath: currentStoryName, withIntermediateDirectories: true, attributes: nil)
        }
        
        //2. 帅选出需要下载的文件url
        let floderAllFiles = getAllFileOfFloder(flodPath: currentStoryName)
        
        let downLoadUrls = urls.filter { url in
            !floderAllFiles.contains(url.lastPathComponent)
        }
        
        guard !downLoadUrls.isEmpty else {
            completion(currentStoryName)
            return
        }
        
        self.downUrls(urlTuple: ([],downLoadUrls)) { f , t , _ in
            
            let savePath = currentStoryName + "/" + t.lastPathComponent
            
            let saveUrl = URL(fileURLWithPath: savePath)
            
            try? fileManager.moveItem(at: f, to: saveUrl)
            
            
        } progress: { p in
            
            progress(p)
            
        } completion: {
            completion(currentStoryName)
        }
    }
    
    
    /// 下载学习卡
    /// - Parameters:
    ///   - urls: 学习卡链接
    ///   - previewImage: 预览图链接
    ///   - studyCardName: 学习卡名称
    ///   - progress: 进度
    ///   - completion: 完成回调
    public func downLoadStudyCard(urls:[URL],appPreviewImage:URL?,wathcPreviewImage:URL,studyCardName:String,languageCode:String,progress: @escaping (Float) -> Void, completion: @escaping (String) -> Void) {
        
        let fileManager = FileManager.default
        
        let studyCardParentName = getSaveFileName(type: .studyCard)
        
        let languageFolder = studyCardParentName + "/" + languageCode
        
        let currentStudyCardName = languageFolder + "/" + studyCardName
        //1. 检查这个学习卡存不存在
        if !fileManager.fileExists(atPath: languageFolder) {
            try? fileManager.createDirectory(atPath: languageFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        // 1.2 判断学习卡文件夹
        if !fileManager.fileExists(atPath: currentStudyCardName) {
            try? fileManager.createDirectory(atPath: currentStudyCardName, withIntermediateDirectories: true, attributes: nil)
        }
        
        //2. 帅选出需要下载的文件url
        let floderAllFiles = getAllFileOfFloder(flodPath: currentStudyCardName)
        
        let downLoadUrls = urls.filter { url in
            !floderAllFiles.contains(url.lastPathComponent)
        }
        
        guard !downLoadUrls.isEmpty else {
            completion(currentStudyCardName)
            return
        }
        
        var previewImageUrls:[URL] = [wathcPreviewImage]
        
        if let appPreviewImage {
            previewImageUrls.append(appPreviewImage)
        }
        
        self.downUrls(urlTuple: (previewImageUrls, downLoadUrls)) { f , t , isPreview in
           
            let savePath = isPreview ? (languageFolder + "/" + t.lastPathComponent) :  (currentStudyCardName + "/" + t.lastPathComponent)
            
            let saveUrl = URL(fileURLWithPath: savePath)
            
            try? fileManager.moveItem(at: f, to: saveUrl)
            
            
        } progress: { p in
            
            progress(p)
            
        } completion: {
            completion(currentStudyCardName)
        }
        
    }
}
