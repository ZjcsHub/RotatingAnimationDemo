//
//  StoryViewController.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/10/18.
//

import UIKit

class StoryViewController: UIViewController {

    var stroyBoolUrls:[String] = []
    var currentIndex  = -1
    var musicPlayer:OplayerMusicPlayer =  OplayerMusicPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     
//        DownLoadTaskTool.shared.dowmLoadStoryBook(urls: testStoryBook(), storyName: "Little_Red_riding_hood", languageCode: "en") { progress in
//            print("下载故事书进度:\(progress)")
//        } completion: { path in
//            print("故事书下载完成路径:\(path)")
//        }
////
//        DownLoadTaskTool.shared.downLoadStudyCard(urls: testStudyCard(), appPreviewImage: URL(string: "https://ota.fozento.com/update/LD/F240X284/en/Animal_app.jpg"), wathcPreviewImage: URL(string: "https://ota.fozento.com/update/LD/F240X284/en/Animal.jpg")!, studyCardName: "Animal", languageCode: "en") { progress in
//            print("下载学习卡进度:\(progress)")
//        } completion: { path in
//            print("学习卡下载完成路径:\(path)")
//        }


//        DownLoadTaskTool.shared.getStudyCardModel(studyCardName: "Animal", languageCode: "en") { m in
//            print("学习卡:\(m)")
//        }
        
        DownLoadTaskTool.shared.getStoryBookModel(storyName: "Little_Red_riding_hood", languageCode: "en", complete: { model in
            print("故事书:\(model)")
            
            self.stroyBoolUrls = model?.allFile.map({ $0.musicPath! }) ?? []
            
            
        })
        
//        stroyBoolUrls = [
//            "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/1.mp3",
//            "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/10.mp3",
//            "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/11.mp3",
//            "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/12.mp3",
//            "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/13.mp3"
//        ]
        
        let button = UIButton(type: .system)
        button.setTitle("上一首", for: .normal)
        button.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        button.addTarget(self, action: #selector(previewAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("下一首", for: .normal)
        nextButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)

        self.view.addSubview(nextButton)
    }
    
    
    @objc func previewAction() {
        guard currentIndex > 0 else {
            return
        }
        currentIndex -= 1
        play()
    }
    
    @objc func nextAction() {
        guard currentIndex < stroyBoolUrls.count - 1 else {
            return
        }
        currentIndex += 1
        
        play()
    }
    
    func play() {
        if currentIndex < stroyBoolUrls.count {
            
            let url = stroyBoolUrls[currentIndex]
            
//            musicPlayer.playNetWorkFile(netUrl: URL(string: url))
            musicPlayer.playLocalFile(url: URL(fileURLWithPath: url))
        }
    }
    

    func testStoryBook() -> [URL] {
        let fileList:[[String:Any]] = [
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/1.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/1.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/10.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/10.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/11.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/11.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/12.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/12.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/13.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/13.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/14.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/14.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/15.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/15.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/16.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/16.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/17.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/17.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/18.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/18.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/19.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/19.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/2.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/2.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/20.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/20.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/21.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/21.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/22.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/22.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/3.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/3.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/4.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/4.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/5.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/5.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/6.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/6.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/7.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/7.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/8.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/8.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/9.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/9.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/1.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/1.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/10.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/10.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/11.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/11.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/12.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/12.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/13.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/13.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/14.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/14.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/15.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/15.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/16.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/16.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/17.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/17.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/18.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/18.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/19.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/19.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/2.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/2.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/20.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/20.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/21.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/21.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/22.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/22.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/3.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/3.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/4.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/4.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/5.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/5.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/6.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/6.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/7.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/7.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/8.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/8.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/9.jpg",
                "video": "https://ota.fozento.com/update/STORY/F240X284/en/0-3/Little_Red_riding_hood/9.mp3"
            ]
        ]
        
       let urls = fileList.reduce([]) { partialResult, dict in
            partialResult + [URL(string: dict["image"] as! String)!,URL(string: dict["video"] as! String)!]
        }
        
        return urls
    }
    
    
    func testStudyCard() -> [URL]{
        
        let fileList:[[String:Any]] = [
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/01_Lion.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/01_Lion.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/02_Monkey.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/02_Monkey.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/03_Dog.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/03_Dog.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/04_Cat.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/04_Cat.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/05_Chicken.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/05_Chicken.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/06_Elephant.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/06_Elephant.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/07_Zebra.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/07_Zebra.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/08_Giraffe.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/08_Giraffe.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/09_Panda.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/09_Panda.mp3"
            ],
            [
                "new": 0,
                "image": "https://ota.fozento.com/update/LD/F240X284/en/Animal/10_Rabbit.jpg",
                "video": "https://ota.fozento.com/update/LD/F240X284/en/Animal/10_Rabbit.mp3"
            ]
        ]
        let urls = fileList.reduce([]) { partialResult, dict in
             partialResult + [URL(string: dict["image"] as! String)!,URL(string: dict["video"] as! String)!]
         }
         
         return urls
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
