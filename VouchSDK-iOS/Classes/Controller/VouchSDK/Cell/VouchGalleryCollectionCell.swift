//
//  VouchGalleryCollectionCell.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 10/09/19.
//

import UIKit

internal class VouchGalleryCollectionCell: UICollectionViewCell {
    // MARK: Outlet
    @IBOutlet weak var galleryImgVw: UIImageView!
    @IBOutlet weak var galleryTitleLbl: UILabel!
    @IBOutlet weak var galleryBtnStackVw: UIStackView!
    
    // MARK: Properties
    private var listButton: [CustomButton] = []
    private var configData: ConfigData?
    private var data: MessageResponseElements?
    private var onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?
    
    private func configureCell(data: MessageResponseElements?, configData: ConfigData?) {
        self.data = data
        self.configData = configData
        self.galleryTitleLbl.text = self.data?.title ?? "-"
        if let image = data?.imageUrl, let url = URL(string: image) {
            self.galleryImgVw.backgroundColor = .clear
            self.galleryImgVw.sd_setImage(with: url, completed: nil)
        } else {
            self.galleryImgVw.image = nil
            self.galleryImgVw.backgroundColor = .lightGray
        }
        self.listButton.forEach { (button) in
            self.galleryBtnStackVw.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        self.listButton.removeAll()
        if listButton.count == 0 {
            var idx = 0
            for dt in data?.buttons ?? [] {
                let button = CustomButton()
                button.tag = idx
                button.borderWidth = 1
                button.cornerRadius = 3
                button.shadow = 0
                button.shadowRadius = 0
                button.setTitle(dt.title, for: .normal)
                button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30))
                button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                button.setTitleColor(Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy), for: .normal)
                button.setTitleColor(Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhite), for: .highlighted)
                button.backgroundColor = .clear
                button.borderColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
                button.addTarget(self, action: #selector(self.buttonTouchUpAction(_:)), for: .touchUpInside)
                button.addTarget(self, action: #selector(self.buttonTouchDownAction(_:)), for: .touchDown)
                button.changeFont(font: configData?.fontStyle ?? "")
                listButton.append(button)
                self.galleryBtnStackVw.addArrangedSubview(button)
                idx += 1
            }
        }
        self.galleryTitleLbl.changeFont(fontText: configData?.fontStyle ?? "")
    }
    
    @objc
    private func buttonTouchUpAction(_ sender: UIButton) {
        sender.backgroundColor = Color.color(value: configData?.backgroundColorChat, defaultColor: Color.colorWhite)
        guard let data = self.data?.buttons?[sender.tag] else { return }
        self.onTapButtonAction?(data.type, data.payload, data.url, data.title)
    }
    
    @objc
    private func buttonTouchDownAction(_ sender: UIButton) {
        sender.backgroundColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy)
    }
}

extension VouchGalleryCollectionCell {
    public static var name = "VouchGalleryCollectionCell"
    
    public static func registerCell(_ collectionView: UICollectionView, bundle: Bundle?) {
        collectionView.register(UINib(nibName: self.name, bundle: bundle), forCellWithReuseIdentifier: self.name)
    }
    
    public static func initCell(_ collectionView: UICollectionView, indexPath: IndexPath, data: MessageResponseElements?, configData: ConfigData?, onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?) -> VouchGalleryCollectionCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.name, for: indexPath) as! VouchGalleryCollectionCell
        cell.onTapButtonAction = onTapButtonAction
        cell.configureCell(data: data, configData: configData)
        return cell
    }
}

