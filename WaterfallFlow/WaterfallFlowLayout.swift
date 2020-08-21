//
//  WaterfallFlowLayout.swift
//  WaterfallFlow
//
//  Created by hdj on 2020/8/20.
//  Copyright © 2020 hdj. All rights reserved.
//

import UIKit

class WaterfallFlowLayout: UICollectionViewFlowLayout {
    // 总列数
    var columnCount:Int = 0
    // 数据数组
    var dataArr = [Int]()
    // 整个collectionView的高度
    private var maxH:Int?
    //所有item的属性
    fileprivate var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        let contentWidth:CGFloat = (self.collectionView?.bounds.size.width)! - self.sectionInset.left - self.sectionInset.right
        let marginX = self.minimumInteritemSpacing
        let itemWidth = (contentWidth - marginX * CGFloat(self.columnCount - 1)) / CGFloat.init(self.columnCount)
        self.computeAttributesWithItemWidth(CGFloat(itemWidth))
    }
    
    ///根据itemWidth计算布局属性
    func computeAttributesWithItemWidth(_ itemWidth:CGFloat){
        
        // 定义一个列高数组 记录每一列的总高度
        var columnHeight = [Int](repeating: Int(self.sectionInset.top), count: self.columnCount)
        // 定义一个记录每一列的总item个数的数组
        var columnItemCount = [Int](repeating: 0, count: self.columnCount)
        var attributesArray = [UICollectionViewLayoutAttributes]()

        // 遍历数据计算每个item的属性并布局
        var index = 0
        for dj_height in self.dataArr {
            
            let indexPath = IndexPath.init(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            // 找出最短列号
            let minHeight:Int = columnHeight.sorted().first!
            let column = columnHeight.firstIndex(of: minHeight)
            // 数据追加在最短列
            columnItemCount[column!] += 1
            let itemX = (itemWidth + self.minimumInteritemSpacing) * CGFloat(column!) + self.sectionInset.left
            let itemY = minHeight
            // 等比例缩放 计算item的高度
            let itemH = dj_height
            // 设置frame
            attributes.frame = CGRect(x: itemX, y: CGFloat(itemY), width: itemWidth, height: CGFloat(itemH))
            
            attributesArray.append(attributes)
            // 累加列高
            columnHeight[column!] += itemH + Int(self.minimumLineSpacing)
            index += 1
        }
        
        // 找出最高列列号
        let maxHeight:Int = columnHeight.sorted().last!
        let column = columnHeight.firstIndex(of: maxHeight)
        // 根据最高列设置itemSize 使用总高度的平均值
        let itemH = (maxHeight - Int(self.minimumLineSpacing) * (columnItemCount[column!] + 1)) / columnItemCount[column!]
        self.itemSize = CGSize(width: itemWidth, height: CGFloat(itemH))
        // 给属性数组设置数值
        self.layoutAttributesArray = attributesArray
        self.maxH = maxHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.layoutAttributesArray
    }
    
    ///重写设置contentSize
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: (collectionView?.bounds.width)!, height: CGFloat(self.maxH!))
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }

}
