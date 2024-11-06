//
//  AgpsSyncingView.swift
//  OplayerSport
//
//  Created by App005 SYNERGY on 2024/3/21.
//  Copyright © 2024 App005 SYNERGY. All rights reserved.
//

import UIKit

class AgpsSyncingView: UIView {
    @IBOutlet weak var syncTitleLabel: UILabel!
    
    @IBOutlet weak var progressBackView: UIView!

    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
   
 
    
    var progress:CGFloat = 0 {
        didSet {
                        
            progressLabel.text = String(format: "%.0f%%", progress * 100)
            
        }
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        
    }
    
    static func loadAgpsSyncView() -> AgpsSyncingView {
        let view = Bundle.main.loadNibNamed("AgpsSyncingView", owner: nil)?.last as! AgpsSyncingView
       
        
     
        return view
    }
    
    
    func showAgpsSyncView(controller:UIViewController)  {
        
        guard let window = controller.view else {
            return
        }
        window.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
       
    }
    
    func removeAgpsSyncView() {
        self.removeFromSuperview()
    }
    
}
