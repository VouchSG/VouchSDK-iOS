//
//  VouchSDKCollectionAdapter.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 05/09/19.
//

import UIKit

enum VouchSDKCollectionEnum: Int {
    case gallery = 0
    case other = 1
}

internal class VouchSDKCollectionAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public var dataManager: VouchSDKDataManager
    public var currentIdx: Int
    public var configData: ConfigData
    public var onTapButtonAction: ((_ msgType: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?
    
    init(dataManager: VouchSDKDataManager, currentIdx: Int, configData: ConfigData) {
        self.dataManager = dataManager
        self.currentIdx = currentIdx
        self.configData = configData
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case VouchSDKCollectionEnum.gallery.rawValue:
            return self.dataManager.listChat[currentIdx].elements?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case VouchSDKCollectionEnum.gallery.rawValue:
            return VouchGalleryCollectionCell.initCell(collectionView, indexPath: indexPath, data: self.dataManager.listChat[self.currentIdx].elements?[indexPath.row], configData: configData, onTapButtonAction: self.onTapButtonAction)
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screeenWidth = UIScreen.main.bounds.width
        switch collectionView.tag {
        case VouchSDKCollectionEnum.gallery.rawValue:
            var currentTotalHeight: CGFloat = 0
            for element in dataManager.listChat[currentIdx].elements ?? [] {
                var totalHeight: CGFloat = 0
                let data = element
                let estimatedImageHeight: CGFloat = 118
                let marginTopBottom: CGFloat = 16
                let text = data.title ?? ""
                let font = UIFont.boldSystemFont(ofSize: 12)
                let titleSize = text.size(withAttributes: [
                    NSAttributedString.Key.font: font
                ])
                totalHeight += estimatedImageHeight + marginTopBottom + titleSize.height + 32
                data.buttons?.forEach({ (button) in
                    totalHeight += 30 + (marginTopBottom/2)
                })
                if currentTotalHeight < totalHeight {
                    currentTotalHeight = totalHeight
                }
            }
            return CGSize(width: screeenWidth / 2.2, height: currentTotalHeight)
        default:
            return .zero
        }
    }
}
