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
    let columnCount:Int = 3;
    // 瀑布流布局
    var flowLayout: WaterfallFlowLayout!

    var collectionView: UICollectionView!
    
    
    //MARK: - --- 视图已经加载
    override func viewDidLoad() {
        super.viewDidLoad()
        // 数据源，同时也是高度值（实际项目中应根据内容计算高度）
        self.dataArr = [300,200,300,400,100,200,300,400,100,200,300,400,100,200,300,400]
        self.createUI()
    }
    
    
    //MARK: - --- 创建UI
    func createUI(){
        // 创建collectionView视图 和 flowLayout布局
        self.flowLayout = WaterfallFlowLayout()
        self.flowLayout.dataArr = self.dataArr
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        let collectionView = UICollectionView.init(frame: rect, collectionViewLayout:self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HomeCell")
        self.view.addSubview(collectionView)
        self.collectionView = collectionView

        // 设置布局属性
        self.setWaterfallFlowLayouts()
        
    }
    
    //MARK: - --- 设置item的布局
    func setWaterfallFlowLayouts(){
        // 设置布局属性
        self.flowLayout.columnCount = self.columnCount
        // 边界
        self.flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        // 设置间距
        self.flowLayout.minimumLineSpacing = 10.0
        self.flowLayout.minimumInteritemSpacing = 10.0
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
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        var label: UILabel!
        
        if let lab: UILabel = cell.contentView.subviews.last as? UILabel{
            label = lab
        }else{
            label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
            label.textAlignment = .center
            cell.contentView.addSubview(label)
            label.textColor = .white
        }
        
        label.text = "\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 点击添加数据
        self.dataArr += [300,200,300,400,100,200,300,400,100,200,300,400,100,200,300,400]
        self.flowLayout.dataArr = self.dataArr
        self.collectionView.reloadData()
    }
}

