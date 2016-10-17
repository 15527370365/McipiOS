//
//  Collection.swift
//  校园微平台
//
//  Created by MAC on 16/7/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class Collection: NSObject {
    var collectionView: UICollectionView
    var indexPath: NSIndexPath
    
    init(collectionView: UICollectionView,indexPath: NSIndexPath) {
        self.collectionView = collectionView
        self.indexPath = indexPath
    }
}
