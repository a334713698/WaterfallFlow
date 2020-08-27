//
//  WaterfallFlowLayout.swift
//  WaterfallFlow
//
//  Created by hdj on 2020/8/20.
//  Copyright © 2020 hdj. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class WaterfallFlowLayout: UICollectionViewFlowLayout {
    // 总列数
    var columnCount:Int = 0
    // 数据数组
    var dataArr = [Int]()
    // 整个collectionView的高度
    private var maxH:Int?
    //所有item的属性
    fileprivate var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
    
    // 准备布局时调用
    override func prepare() {
        /**
         *  计算每个item的宽度
         *  即：(collectionView的宽度 - 左右边距和 - item的水平间距之和) / 每行的item数量
         */
        let itemWidth = ((self.collectionView?.bounds.size.width)! - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * CGFloat(self.columnCount - 1)) / CGFloat.init(self.columnCount)
        
        // 通过item的宽度，计算并设置属性
        self.computeAttributesWithItemWidth(CGFloat(itemWidth))
    }
    
    ///根据itemWidth计算布局属性
    func computeAttributesWithItemWidth(_ itemWidth:CGFloat){
        
        // 定义一个列高数组 记录每一列的总高度（初始值都为上边距）
        var columnHeightArr = [Int](repeating: Int(self.sectionInset.top), count: self.columnCount)
        // 定义一个 记录每一列的item个数的数组
        var columnItemCountArr = [Int](repeating: 0, count: self.columnCount)
        
        // 定义一个 存储属性的临时数组
        var attributesArray = [UICollectionViewLayoutAttributes]()

        // 遍历数据计算每个item的属性并布局
        for (index, dj_height) in self.dataArr.enumerated() {
            
            // 根据IndexPath获取Cell元素的属性
            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(item: index, section: 0))
            // 找出最短列的下标
            let minHeight:Int = columnHeightArr.sorted().first!
            let column = columnHeightArr.firstIndex(of: minHeight)
            
            // 将数据追加在最短列
            columnItemCountArr[column!] += 1
            // 计算该项的坐标
            let itemX = (itemWidth + self.minimumInteritemSpacing) * CGFloat(column!) + self.sectionInset.left
            let itemY = minHeight
            // 计算item的高度（机型适配，注意比例缩放）
            let itemH = dj_height
            // 设置frame
            attributes.frame = CGRect(x: itemX, y: CGFloat(itemY), width: itemWidth, height: CGFloat(itemH))
            
            attributesArray.append(attributes)
            // 累加列高
            columnHeightArr[column!] += itemH + Int(self.minimumLineSpacing)
        }
        
        // 找出最高列的下标
        let maxHeight:Int = columnHeightArr.sorted().last!
        let maxHeightColumnIndex = columnHeightArr.firstIndex(of: maxHeight)
        // 根据最高列设置itemSize的默认值 使用总高度的平均值
        let itemH = (maxHeight - Int(self.minimumLineSpacing) * (columnItemCountArr[maxHeightColumnIndex!] + 1)) / columnItemCountArr[maxHeightColumnIndex!]
        self.itemSize = CGSize(width: itemWidth, height: CGFloat(itemH))
        // 给属性数组设置数值
        self.layoutAttributesArray = attributesArray
        // 将最高列的行高赋值给属性，作为contentSize.Height的值
        self.maxH = maxHeight
    }
    
    // 返回计算好的layoutAttributesArray数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.layoutAttributesArray
    }
    
    // 重写设置contentSize
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: (collectionView?.bounds.width)!, height: CGFloat(self.maxH!))
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }

}
