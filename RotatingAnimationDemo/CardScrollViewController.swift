//
//  CardScrollViewController.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2024/8/15.
//

import UIKit
import SnapKit
class CardScrollViewController: UIViewController {
    
    private let cellID = "baseCellID"
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setUpView() {
        // 初始化 flowlayout
        let layout = CoverFlowLayout()
        let margin: CGFloat = 20
        let collH: CGFloat = 400
        let itemH = collH - margin * 2
        let itemW = view.bounds.width - margin * 2 - 100
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        layout.scrollDirection = .horizontal
        
        // 初始化 collectionview
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: collH), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册 Cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        view.addSubview(collectionView)
       
    }
}

extension CardScrollViewController:UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = indexPath.item % 2 == 0 ? .purple : .red
        return cell
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("结束滑动")
    }
}
