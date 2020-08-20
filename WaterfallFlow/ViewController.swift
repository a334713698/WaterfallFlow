//
//  ViewController.swift
//  WaterfallFlow
//
//  Created by hdj on 2020/8/18.
//  Copyright © 2020 hdj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 数据源
    var dataArr = [Int]()
    // 列数
    var columnCount:Int = 2;
    // 瀑布流布局
    var flowLayout: WaterfallFlowLayout!
    
    var itemWidth:CGFloat = 0
    
    var collectionView: UICollectionView!
    
    
    //MARK: - --- 视图已经加载
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArr = [111,222,333,444,111,222,333,444,111,222,333,444,111,222,333,444]
        self.createUI()
    }
    
    //MARK: - --- 视图即将出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - --- 创建UI
    func createUI(){
        self.flowLayout = WaterfallFlowLayout()
        self.flowLayout.dataArr = self.dataArr
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.collectionView = UICollectionView.init(frame: rect, collectionViewLayout:self.flowLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HomeCell")

        
        self.setWaterfallFlowLayouts()
        
    }
    
    //MARK: - --- 设置item的布局
    func setWaterfallFlowLayouts(){
        //通过layout的一些参数设置item的宽度
        let inset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        let minLine:CGFloat = 10.0
        self.itemWidth = (SCREEN_WIDTH - inset.left - inset.right - minLine * (CGFloat(self.columnCount - 1))) / CGFloat(self.columnCount)
        
        //设置布局属性
        self.flowLayout.columnCount = self.columnCount
        self.flowLayout.sectionInset = inset
        self.flowLayout.minimumLineSpacing = minLine
    }
    
    //MARK: - --- delegate，dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
        
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}

