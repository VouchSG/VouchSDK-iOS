//
//  DynamicHeightCollectionView.swift
//  DynamicHeightCollectionView
//
//  Created by Payal Gupta on 11/02/19.
//  Copyright © 2019 Payal Gupta. All rights reserved.
//
import UIKit

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var content = self.contentSize
        content.height = content.height + 16
        return content
    }
}
