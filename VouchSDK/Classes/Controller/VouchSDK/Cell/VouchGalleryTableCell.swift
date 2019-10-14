//
//  VouchGalleryTableCell.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 10/09/19.
//

import UIKit

internal class VouchGalleryTableCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    private func configureCell(adapter: VouchSDKCollectionAdapter) {
        VouchGalleryCollectionCell.registerCell(self.collectionVw, bundle: VouchSDKViewController.bundleVouch)
        self.collectionVw.dataSource = adapter
        self.collectionVw.delegate = adapter
        self.collectionVw.reloadData()
        
        var currentTotalHeight: CGFloat = 0
        for element in adapter.dataManager.listChat[adapter.currentIdx].elements ?? [] {
            var totalHeight: CGFloat = 0
            let data = element
            let estimatedImageHeight: CGFloat = 118
            let marginTopBottom: CGFloat = 16
            let text = data.title ?? ""
            let font = UIFont.boldSystemFont(ofSize: 12)
            let titleSize = text.size(withAttributes: [
                NSAttributedString.Key.font: font
                ])
            totalHeight += estimatedImageHeight + marginTopBottom + titleSize.height + 16
            data.buttons?.forEach({ (button) in
                totalHeight += 30 + (marginTopBottom/2)
            })
            if currentTotalHeight < totalHeight {
                currentTotalHeight = totalHeight
            }
        }
        self.collectionHeight.constant = currentTotalHeight + 16
    }
}

extension VouchGalleryTableCell {
    public static var name = "VouchGalleryTableCell"
    
    public static func registerCell(_ tableView: UITableView, bundle: Bundle?) {
        tableView.register(UINib(nibName: self.name, bundle: bundle), forCellReuseIdentifier: self.name)
    }
    
    public static func initCell(_ tableView: UITableView, indexPath: IndexPath, adapter: VouchSDKCollectionAdapter) -> VouchGalleryTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.name, for: indexPath) as! VouchGalleryTableCell
        cell.configureCell(adapter: adapter)
        cell.selectionStyle = .none
        return cell
    }
}
